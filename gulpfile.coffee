gulp      = require('gulp')
plumber   = require('gulp-plumber')
util      = require('gulp-util')
sass      = require('gulp-ruby-sass')
del       = require('del')
uglify    = require('gulp-uglify')
minifyCSS = require('gulp-minify-css')
streamify = require('gulp-streamify')
size      = require('gulp-size')
tap       = require('gulp-tap')
rev       = require('gulp-rev')
extend    = require('gulp-extend')
rename    = require('gulp-rename')
manifest  = require('gulp-rev-rails-manifest')
sourcemaps = require('gulp-sourcemaps')

browserify = require('browserify')
ts         = require('tsify')
source     = require('vinyl-source-stream')
espowerify = require('espowerify')
mold       = require('mold-source-map')
deepExtend = require('deep-extend')

path        = require('path')
fs          = require('fs')
pkg         = require(__dirname + '/package.json')

minify = false
environment = process.env['ENV'] || 'development'

if environment == 'production'
  minify = true


gulp.task 'clean', (cb) ->
  del(['public/assets'], cb)


### browserify ###########################################
getBundler = (filepath, opts = {}) ->
  extensions = opts.extensions
  plugins    = opts.plugins ? []
  transforms = opts.transforms ? []

  browserifyOpts =
    entries: [filepath]
    debug: true
  browserifyOpts.extensions = extensions if extensions?

  bundler = browserify(browserifyOpts)

  for p in plugins
    if typeof p == "object"
      for k, o of p
        bundler = bundler.plugin(k, o).on('error', util.log)
    else
      bundler = bundler.plugin(p).on('error', util.log)

  for t in transforms
    if typeof t == "object"
      for k, o of t
        bundler = bundler.transform(o, require(k))
    else
      bundler = bundler.transform(require(t))
  bundler

gulp.task 'browserify', ->
  entries = pkg.browserify.entryScripts
  gulp.src(entries)
    .pipe(tap (file) ->
      extname = path.extname(file.path)
      output = path.basename(file.path, extname) + '.js'

      bundler = if extname == ".ts"
        getBundler(file.path, {
          extensions: [".ts"]
          plugins: ["tsify"]
          transforms: ["browserify-shim", "vueify", "brfs", "espowerify"]
        }).bundle().pipe(source(output))
      else
        getBundler(file.path, {
          extensions: [".coffee"]
          transforms: ["coffeeify", "browserify-shim", "vueify", "brfs", "espowerify"]
        }).bundle().on('error', util.log).pipe(source(output))

      stream = if minify
        bundler.pipe(streamify(uglify()))
          .pipe(streamify(size()))
          .pipe(streamify(rev()))
          .pipe(gulp.dest("public/assets"))
          .pipe(manifest(path: 'js-manifest.json'))
          .pipe(gulp.dest("public/assets"))
      else
        bundler
          .pipe(streamify(size()))
          .pipe(gulp.dest("public/assets"))

      stream
    )

gulp.task 'browserify-test', ->
  entries = ['./spec/javascripts/**/*_spec.{js,coffee,ts}']
  gulp.src(entries)
    .pipe(tap (file) ->
      extname = path.extname(file.path)
      output = path.basename(file.path, extname) + '.js'

      bundler = if extname == ".ts"
        getBundler(file.path, {
          extensions: [".ts"]
          plugins: ["tsify"]
          transforms: ["browserify-shim", "vueify", "brfs", "espowerify"]
        }).bundle()
      else
        getBundler(file.path, {
          extensions: [".coffee"]
          transforms: ["coffeeify", "browserify-shim", "vueify", "brfs", "espowerify"]
        }).bundle().on('error', util.log)

      bundler
        .pipe(mold.transformSourcesRelativeTo(__dirname))
        .pipe(source(output))
        .pipe(gulp.dest("spec/.powered-javascripts"))
    )


### sass ###########################################
gulp.task 'glyphicon', ->
  gulp.src('bower_components/bootstrap-sass-official/assets/fonts/bootstrap/glyphicons-halflings-regular.*')
    .pipe(gulp.dest("public/assets/fonts/bootstrap"))

gulp.task 'sass', ['glyphicon'], ->
  css = sass('frontend/assets/stylesheets', {
    sourcemap: true
    compass: true
    bundleExec: true
    loadPath: [
      "./bower_components"
    ]
  }).on('error', (err) ->
    console.error('Error', err.message)
  )
    .pipe(sourcemaps.write())

  stream = if minify
    css.pipe(minifyCSS())
      .pipe(size())
      .pipe(rev())
      .pipe(gulp.dest("public/assets"))
      .pipe(manifest(path: "css-manifest.json"))
      .pipe(gulp.dest("public/assets"))
  else
    css.pipe(gulp.dest("public/assets"))

  stream


### manifest merging #########################
gulp.task 'manifest', ['browserify', 'sass'], ->
  if fs.existsSync('public/assets/js-manifest.json') && fs.existsSync('public/assets/css-manifest.json')
    jsManifest = JSON.parse(fs.readFileSync('public/assets/js-manifest.json'))
    cssManifest = JSON.parse(fs.readFileSync('public/assets/css-manifest.json'))
    merged = deepExtend(jsManifest, cssManifest)
    fs.writeFileSync('public/assets/manifest.json', JSON.stringify(merged))


### browserSync ###########################################
try
  browserSync = require('browser-sync')

  gulp.task 'browser-sync', ->
    browserSync
      proxy: "http://localhost:3000"

  gulp.task 'bs-reload', ->
    browserSync.reload()

  ### watch ###########################################
  gulp.task 'watch', ['browser-sync'], ->
    gulp.watch('frontend/assets/javascripts/**/*.{js,coffee,ts,vue}', ['browserify'])
    gulp.watch('frontend/assets/stylesheets/**/*.{scss,sass}', ['sass'])
    gulp.watch([
      'public/assets/**/*.js',
      'public/assets/**/*.css',
    ], ['bs-reload'])
catch error

gulp.task 'default', ['browserify', 'sass', 'manifest']

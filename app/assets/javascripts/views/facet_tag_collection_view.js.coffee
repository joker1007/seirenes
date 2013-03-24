Seirenes.FacetTagCollectionView = Ember.CollectionView.extend
  itemViewClass: Ember.View.extend
    tagName: "span"
    classNames: ["tag"]
    template: Ember.Handlebars.compile("{{name}}({{count}})")

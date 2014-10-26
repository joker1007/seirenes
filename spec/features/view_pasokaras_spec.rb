require 'spec_helper'

feature "Pasokaraの一覧を表示する", elasticsearch: true do
  include_context "indexed_pasokara"

  scenario "トップページを表示する" do
    visit root_path
    expect(page).to have_selector(".pasokara")
    expect(page.find(".title")).to have_content(pasokara.title)
  end

  scenario "キーワードで検索する" do
    visit root_path
    expect(page).to have_selector(".pasokara")

    fill_in "q", with: "存在しない曲名"
    click_button "検索"

    expect(page).not_to have_selector(".pasokara")

    fill_in "q", with: "ペガサス"
    click_button "検索"

    expect(page).to have_selector(".pasokara")
  end

  scenario "動画をオンデマンドでエンコードしてプレビュー再生できる", js: true, redis: true, sidekiq: true do
    visit pasokara_path(pasokara)

    expect(page).not_to have_selector("#preview-player")
    Timeout.timeout(10) do
      loop do
        break if page.has_selector?("#preview-player")
        sleep 0.5
      end
    end
    expect(page).to have_selector("#preview-player")
  end
end

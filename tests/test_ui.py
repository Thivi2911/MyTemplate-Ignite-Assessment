from playwright.sync_api import Page, expect


def test_homepage_displays_mytemplate(page: Page):
    page.goto("http://localhost:5000")

    expect(page).to_have_title("MyTemplate")
    expect(page.get_by_text("MyTemplate").first).to_be_visible()
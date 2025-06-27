# frozen_string_literal: true

require "test_helper"

class SelectComponentTest < ViewComponent::TestCase
  def test_render_with_form_builder
    form_builder = stub_form_builder
    options = [
      { value: 30, icon: "calendar", title: "Medium", description: "Build lasting habits" }
    ]
    
    render_inline(SelectComponent.new(form: form_builder, field: :duration, selected: 30, options: options))
    
    # Test native select structure
    assert_selector "select.custom-select"
    assert_selector "select option", count: 1
    assert_selector "select option[value='30'][selected]"
  end

  def test_render_displays_selected_option_content
    form_builder = stub_form_builder
    options = [
      { value: 14, icon: "target", title: "Short", description: "Ideal for focused challenges" }
    ]
    
    render_inline(SelectComponent.new(form: form_builder, field: :duration, selected: 14, options: options))
    
    # Test selectedcontent shows selected option details
    selectedcontent = page.find("selectedcontent")
    assert selectedcontent.has_text?("Short")
    assert selectedcontent.has_text?("Ideal for focused challenges")
  end

  def test_render_with_multiple_options
    form_builder = stub_form_builder
    options = [
      { value: 7, icon: "zap", title: "Tiny", description: "Perfect for quick habit building" },
      { value: 14, icon: "target", title: "Short", description: "Ideal for focused challenges" }
    ]
    
    render_inline(SelectComponent.new(form: form_builder, field: :duration, selected: 7, options: options))
    
    # Test all options are present
    assert page.has_text?("Tiny")
    assert page.has_text?("Perfect for quick habit building")
    assert page.has_text?("Short")
    assert page.has_text?("Ideal for focused challenges")
  end

  def test_render_includes_icons_in_options
    form_builder = stub_form_builder
    options = [
      { value: 90, icon: "trending-up", title: "Long", description: "Transform your lifestyle" }
    ]
    
    render_inline(SelectComponent.new(form: form_builder, field: :duration, selected: 90, options: options))
    
    # Check that icons are present (assuming lucide_icon helper creates SVG)
    assert page.has_selector?("svg", minimum: 2) # 1 option + 1 in selectedcontent + chevron icon
  end

  def test_render_with_different_field_name
    form_builder = stub_form_builder
    options = [
      { value: "happy", icon: "smile", title: "Happy", description: "Feeling great" }
    ]
    
    render_inline(SelectComponent.new(form: form_builder, field: :mood, selected: "happy", options: options))
    
    # Test field name is used correctly
    assert_selector "select[name='habit[mood]']"
    assert_selector "select option[value='happy'][selected]"
  end

  def test_render_with_emoji_icons
    form_builder = stub_form_builder
    options = [
      { value: "happy", icon: "😀", title: "Happy", description: "Feeling great" },
      { value: "sad", icon: "😞", title: "Sad", description: "Feeling down" }
    ]
    
    render_inline(SelectComponent.new(form: form_builder, field: :mood, selected: "happy", options: options))
    
    # Test emoji icons are rendered
    assert page.has_text?("😀")
    assert page.has_text?("😞")
    assert page.has_text?("Happy")
    assert page.has_text?("Sad")
  end

  def test_render_with_lucide_icons
    form_builder = stub_form_builder
    options = [
      { value: 30, icon: "calendar", title: "Medium", description: "Build lasting habits" }
    ]
    
    render_inline(SelectComponent.new(form: form_builder, field: :duration, selected: 30, options: options))
    
    # Test lucide icons are rendered as SVG
    assert page.has_selector?("svg")
    assert page.has_text?("Medium")
  end

  def test_render_includes_modern_select_styling
    form_builder = stub_form_builder
    options = [
      { value: 30, icon: "calendar", title: "Medium", description: "Build lasting habits" }
    ]
    
    render_inline(SelectComponent.new(form: form_builder, field: :duration, selected: 30, options: options))
    
    assert_selector "select.custom-select"
    assert page.has_css?("style", text: "appearance: base-select", visible: false)
  end

  def test_defaults_to_first_option_when_no_selection
    form_builder = stub_form_builder
    options = [
      { value: 7, icon: "zap", title: "Tiny", description: "Perfect for quick habit building" }
    ]
    
    render_inline(SelectComponent.new(form: form_builder, field: :duration, options: options))
    
    # Should default to first option
    selectedcontent = page.find("selectedcontent")
    assert selectedcontent.has_text?("Tiny")
  end

  private

  def stub_form_builder
    habit = Habit.new
    template = ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil)
    ActionView::Helpers::FormBuilder.new(:habit, habit, template, {})
  end
end
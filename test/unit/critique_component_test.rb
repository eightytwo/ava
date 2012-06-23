require 'test_helper'

class CritiqueComponentTest < ActiveSupport::TestCase
  test "create with missing details" do
    component = CritiqueComponent.new
    
    assert !component.save, "Saved a critique component without any details."
  end

  test "update with nil critique" do
    component = CritiqueComponent.find(
      critique_components(:haddock_critique_one_component_one).id)
    component.critique_id = nil
    
    assert(
      !component.save,
      "Saved a component with a nil critique reference.")
  end

  test "update with a nonexistent critique" do
    component = CritiqueComponent.find(
      critique_components(:haddock_critique_one_component_one).id)
    component.critique_id = 0
    
    begin
      component.save
      assert(
        false,
        "Saved a component with a reference to a nonexistent critique.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "update with nil critique category" do
    component = CritiqueComponent.find(
      critique_components(:haddock_critique_one_component_one).id)
    component.critique_category_id = nil
    
    assert(
      !component.save,
      "Saved a component with a nil critique category reference.")
  end

  test "update with a nonexistent user" do
    component = CritiqueComponent.find(
      critique_components(:haddock_critique_one_component_one).id)
    component.critique_category_id = 0
    
    begin
      component.save
      assert(
        false,
        "Saved a component with a reference to a nonexistent critique category.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end
end

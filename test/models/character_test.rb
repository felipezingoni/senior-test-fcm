require 'test_helper'
class CharacterTest < ActiveSupport::TestCase
  #validation create character tests
  test "should save valid character" do
    character = Character.new(name: "Jon Snow", description: "Knows nothing")
    assert character.save, "Failed to save a valid character"
  end

  test "should not save character without name" do
    character = Character.new(description: "No name provided")
    assert_not character.save, "Saved the character without a name"
  end

  test "parents method returns correct parents" do
    character = Character.new(name: "Jon Snow",father: "Ned Stark", mother: "Catelyn Stark")
    expected_parents = { father: "Ned Stark", mother: "Catelyn Stark" }
    assert_equal expected_parents, character.parents, "El método parents no devolvió los valores correctos"
  end

  test "siblings method returns correct siblings" do
    character = Character.new(name: "Jon Snow", siblings: "Catelyn Stark")
    expected_brothers = ["Catelyn Stark"]
    assert_equal expected_brothers, character.brothers, "El método siblings no devolvió los valores correctos"
  end

end

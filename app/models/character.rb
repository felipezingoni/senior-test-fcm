# == Schema Information
#
# Table name: characters
#
#  id                  :integer          not null, primary key
#  name                :string
#  house_id            :integer
#  description         :string
#  biography           :string
#  personality         :string
#  titles              :string
#  status              :string
#  death               :string
#  origin              :string
#  allegiance          :string
#  religion            :string
#  predecessor         :string
#  successor           :string
#  father              :string
#  mother              :string
#  spouse              :string
#  children            :string
#  siblings            :string
#  lovers              :string
#  culture             :string
#  appears_in_season_1 :boolean
#  appears_in_season_2 :boolean
#  appears_in_season_3 :boolean
#  appears_in_season_4 :boolean
#  appears_in_season_5 :boolean
#  appears_in_season_6 :boolean
#  appears_in_season_7 :boolean
#  appears_in_season_8 :boolean
#  appears_in_season_9 :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Character < ApplicationRecord
  belongs_to :house, inverse_of: :characters
  has_many :images, as: :imageable, inverse_of: :imageable

  validates :name, :description, presence: true

  # Issue #2
  # Métodos para family relationships
  def grandparents
    grandparents = []

    father = Character.find_by(name: self.father)
    mother = Character.find_by(name: self.mother)

    grandparents << Character.find_by(name: father.father) if father&.father
    grandparents << Character.find_by(name: father.mother) if father&.mother
    grandparents << Character.find_by(name: mother.father) if mother&.father
    grandparents << Character.find_by(name: mother.mother) if mother&.mother

    grandparents.compact
  end

  def parents
    { father: self.father, mother: self.mother }
  end

  def brothers
    self.siblings.split(',').map(&:strip)
  end

  def childrens
    self.children.split(',').map(&:strip)
  end

  def step_siblings
    father = Character.find_by(name: self.father)
    mother = Character.find_by(name: self.mother)

    all_siblings = siblings_of(father) + siblings_of(mother)

    all_siblings.uniq.reject { |sibling| sibling.name == self.name || sibling.father == self.father && sibling.mother == self.mother }
  end

  def grandchildren
    grandchildren = []

    children_names = self.children.split(',').map(&:strip)

    children_names.each do |child_name|
      child = Character.find_by(name: child_name)
      next unless child

      child.children.split(',').map(&:strip).each do |grandchild_name|
        grandchild = Character.find_by(name: grandchild_name)
        grandchildren << grandchild if grandchild
      end
    end
    grandchildren
  end

  def uncles_and_aunts
    uncles_and_aunts = []

    father = Character.find_by(name: self.father)
    mother = Character.find_by(name: self.mother)

    uncles_and_aunts += siblings_of(father) if father
    uncles_and_aunts += siblings_of(mother) if mother

    uncles_and_aunts.uniq.compact
  end

  def cousins
    cousins = []

    uncles_and_aunts = self.uncles_and_aunts

    uncles_and_aunts.each do |uncle_or_aunt|
      uncle_or_aunt.children.split(',').map(&:strip).each do |cousin_name|
        cousin = Character.find_by(name: cousin_name)
        cousins << cousin if cousin
      end
    end

    cousins.uniq.compact
  end

  private

  def siblings_of(character)
    return [] unless character

    character.children.split(',').map(&:strip).map { |child_name| Character.find_by(name: child_name) }.compact
  end
end

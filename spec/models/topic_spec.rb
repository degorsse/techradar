require "rails_helper"

describe Topic do
  before do
    # uniqueness matcher requires an existing record:
    # https://github.com/thoughtbot/shoulda-matchers/issues/300
    user = create(:user)
    create(:topic, creator: user)
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:creator_id) }

  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_uniqueness_of(:slug) }

  it { is_expected.to have_many(:blips) }

  it { is_expected.to belong_to(:creator).class_name("User") }
  it { is_expected.to validate_presence_of(:creator) }

  describe ".techradar", :admin do
    it "uses the existing topic if present" do
      existing = create(:topic, name: "techradar.io", creator: User.admin)

      result = described_class.techradar

      expect(result.id).to eq existing.id
    end

    it "creates the  topic if not present" do
      result = described_class.techradar

      expect(result.name).to eq "techradar.io"
    end
  end
end

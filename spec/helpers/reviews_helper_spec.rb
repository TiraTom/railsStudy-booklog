require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ReviewsHelper. For example:
#
# describe ReviewsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ReviewsHelper, type: :helper do
  
  describe 'review_average' do 
  
    it 'レビューがない場合は０を返す' do
      expect(review_average([])).to eq 0
    end
  
    describe 'レビューがある場合は' do
      it 'その平均値を返す（整数値のパターン）' do
        expect(review_average([create(:review, rank: 2), create(:review, rank: 4)])).to eq 3
      end
  
      it 'その平均値を返す（小数第１位を含むパターン）' do
        expect(review_average([create(:review, rank: 3), create(:review, rank: 4)])).to eq 3.5
      end
  
      it 'その平均点を返す（小数第二位以下も含むパターン)' do
        expect(review_average([create(:review, rank: 2), create(:review, rank: 2), create(:review, rank:3)])).to eq 2.33
      end
    end
  end

end

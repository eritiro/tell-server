require 'spec_helper'

describe ApplicationController do
  describe "#authenticate_user_from_token!" do
    context "with credential headers" do
      it "user is signed in" do
        user = create(:user)
        subject.request.headers["user_id"] = user.id
        subject.request.headers["user_token"] = user.authentication_token

        subject.send(:authenticate_user_from_token!)
        subject.user_signed_in?.should be true
      end
    end

    context "without credential headers" do
      it "user is not signed in" do
        subject.send(:authenticate_user_from_token!)
        subject.user_signed_in?.should be false
      end
    end
  end
end

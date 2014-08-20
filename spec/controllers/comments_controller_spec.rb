require 'spec_helper'

describe CommentsController do
  let(:location) { create :location }

  before { sign_in create(:user) }

  describe "GET index" do
    it "assigns all comments as @comments" do
      comment = create(:comment, location_id: location.to_param)
      get :index, {location_id: location.to_param}
      assigns(:comments).should eq([comment])
    end
  end

  describe "GET show" do
    it "assigns the requested comment as @comment" do
      comment = create(:comment, location_id: location.to_param)
      get :show, {:id => comment.to_param, location_id: location.to_param}
      assigns(:comment).should eq(comment)
    end
  end

  describe "GET new" do
    it "assigns a new comment as @comment" do
      get :new, {location_id: location.to_param}
      assigns(:comment).should be_a_new(Comment)
    end
  end

  describe "GET edit" do
    it "assigns the requested comment as @comment" do
      comment = create(:comment, location_id: location.to_param)
      get :edit, {:id => comment.to_param, location_id: location.to_param}
      assigns(:comment).should eq(comment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, {:comment => attributes_for(:comment), location_id: location.to_param}
        }.to change(Comment, :count).by(1)
      end

      it "responds to json" do
        post :create, {:comment => attributes_for(:comment), location_id: location.to_param, format: :json}
      end

      it "assigns a newly created comment as @comment" do
        post :create, {:comment => attributes_for(:comment), location_id: location.to_param}
        assigns(:comment).should be_a(Comment)
        assigns(:comment).should be_persisted
      end

      it "redirects to the created comment" do
        post :create, {:comment => attributes_for(:comment), location_id: location.to_param}
        response.should redirect_to([location, Comment.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        post :create, {:comment => { "text" => "invalid value" }, location_id: location.to_param}
        assigns(:comment).should be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        post :create, {:comment => { "text" => "invalid value" }, location_id: location.to_param}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested comment" do
        comment = create(:comment, location_id: location.to_param)
        # Assuming there are no other comments in the database, this
        # specifies that the Comment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Comment.any_instance.should_receive(:update).with({ "text" => "MyString" })
        put :update, {:id => comment.to_param, :comment => { "text" => "MyString" }, location_id: location.to_param}
      end

      it "assigns the requested comment as @comment" do
        comment = create(:comment, location_id: location.to_param)
        put :update, {:id => comment.to_param, :comment => attributes_for(:comment), location_id: location.to_param}
        assigns(:comment).should eq(comment)
      end

      it "redirects to the comment" do
        comment = create(:comment, location_id: location.to_param)
        put :update, {:id => comment.to_param, :comment => attributes_for(:comment), location_id: location.to_param}
        response.should redirect_to([location, comment])
      end
    end

    describe "with invalid params" do
      it "assigns the comment as @comment" do
        comment = create(:comment, location_id: location.to_param)
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        put :update, {:id => comment.to_param, :comment => { "text" => "invalid value" }, location_id: location.to_param}
        assigns(:comment).should eq(comment)
      end

      it "re-renders the 'edit' template" do
        comment = create(:comment, location_id: location.to_param)
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        put :update, {:id => comment.to_param, :comment => { "text" => "invalid value" }, location_id: location.to_param}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested comment" do
      comment = create(:comment, location_id: location.to_param)
      expect {
        delete :destroy, {:id => comment.to_param, location_id: location.to_param}
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the comments list" do
      comment = create(:comment, location_id: location.to_param)
      delete :destroy, {:id => comment.to_param, location_id: location.to_param}
      response.should redirect_to(location_comments_url(location))
    end
  end

end

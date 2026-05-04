require "rails_helper"

RSpec.describe "Posts", type: :request do
  let(:valid_attributes) do
    {
      name: "Jane Doe",
      title: "RSpec request spec",
      content: "Covers the posts controller"
    }
  end

  let(:new_attributes) do
    {
      name: "John Doe",
      title: "Updated post",
      content: "Updated content"
    }
  end

  describe "GET /posts" do
    it "renders a successful response" do
      Post.create!(valid_attributes)

      get posts_url

      expect(response).to be_successful
      expect(response.body).to include("RSpec request spec")
    end
  end

  describe "GET /posts.json" do
    it "renders posts as JSON" do
      post = Post.create!(valid_attributes)

      get posts_url(format: :json)

      json = response.parsed_body.find { |item| item["id"] == post.id }
      expect(response).to be_successful
      expect(json).to include(
        "id" => post.id,
        "name" => "Jane Doe",
        "title" => "RSpec request spec",
        "content" => "Covers the posts controller"
      )
    end
  end

  describe "GET /posts/:id" do
    it "renders a successful response" do
      post = Post.create!(valid_attributes)

      get post_url(post)

      expect(response).to be_successful
      expect(response.body).to include("RSpec request spec")
    end
  end

  describe "GET /posts/:id.json" do
    it "renders the post as JSON" do
      post = Post.create!(valid_attributes)

      get post_url(post, format: :json)

      expect(response).to be_successful
      expect(response.parsed_body).to include(
        "id" => post.id,
        "name" => "Jane Doe",
        "title" => "RSpec request spec",
        "content" => "Covers the posts controller"
      )
    end
  end

  describe "GET /posts/new" do
    it "renders a successful response" do
      get new_post_url

      expect(response).to be_successful
    end
  end

  describe "GET /posts/:id/edit" do
    it "renders a successful response" do
      post = Post.create!(valid_attributes)

      get edit_post_url(post)

      expect(response).to be_successful
    end
  end

  describe "POST /posts" do
    context "with valid parameters" do
      it "creates a new post" do
        expect do
          post posts_url, params: { post: valid_attributes }
        end.to change(Post, :count).by(1)
      end

      it "redirects to the created post" do
        post posts_url, params: { post: valid_attributes }

        expect(response).to redirect_to(Post.last)
        expect(flash[:notice]).to eq("Post was successfully created.")
      end

      it "creates a post as JSON" do
        expect do
          post posts_url(format: :json), params: { post: valid_attributes }
        end.to change(Post, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.location).to eq(post_url(Post.last))
        expect(response.parsed_body).to include(
          "id" => Post.last.id,
          "name" => "Jane Doe",
          "title" => "RSpec request spec",
          "content" => "Covers the posts controller"
        )
      end
    end

    context "when the post cannot be saved" do
      before do
        allow_any_instance_of(Post).to receive(:save).and_return(false)
      end

      it "renders a response with unprocessable entity status" do
        post posts_url, params: { post: valid_attributes }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("New post")
      end

      it "renders errors as JSON" do
        post posts_url(format: :json), params: { post: valid_attributes }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body).to eq({})
      end
    end
  end

  describe "PATCH /posts/:id" do
    context "with valid parameters" do
      it "updates the requested post" do
        post = Post.create!(valid_attributes)

        patch post_url(post), params: { post: new_attributes }

        post.reload
        expect(post.name).to eq("John Doe")
        expect(post.title).to eq("Updated post")
        expect(post.content).to eq("Updated content")
      end

      it "redirects to the post" do
        post = Post.create!(valid_attributes)

        patch post_url(post), params: { post: new_attributes }

        expect(response).to redirect_to(post)
        expect(response).to have_http_status(:see_other)
        expect(flash[:notice]).to eq("Post was successfully updated.")
      end

      it "updates the post as JSON" do
        post = Post.create!(valid_attributes)

        patch post_url(post, format: :json), params: { post: new_attributes }

        expect(response).to have_http_status(:ok)
        expect(response.location).to eq(post_url(post))
        expect(response.parsed_body).to include(
          "id" => post.id,
          "name" => "John Doe",
          "title" => "Updated post",
          "content" => "Updated content"
        )
      end
    end

    context "when the post cannot be updated" do
      before do
        allow_any_instance_of(Post).to receive(:update).and_return(false)
      end

      it "renders a response with unprocessable entity status" do
        post = Post.create!(valid_attributes)

        patch post_url(post), params: { post: new_attributes }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Editing post")
      end

      it "renders errors as JSON" do
        post = Post.create!(valid_attributes)

        patch post_url(post, format: :json), params: { post: new_attributes }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body).to eq({})
      end
    end
  end

  describe "DELETE /posts/:id" do
    it "destroys the requested post" do
      post = Post.create!(valid_attributes)

      expect do
        delete post_url(post)
      end.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      post = Post.create!(valid_attributes)

      delete post_url(post)

      expect(response).to redirect_to(posts_url)
      expect(response).to have_http_status(:see_other)
      expect(flash[:notice]).to eq("Post was successfully destroyed.")
    end

    it "destroys the post as JSON" do
      post = Post.create!(valid_attributes)

      expect do
        delete post_url(post, format: :json)
      end.to change(Post, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end

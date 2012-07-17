require 'test_helper'

# Controllers should never hit the database. Period.
# Ryan Bates and others args that they dont test controllers most of the time
# and when they do, they are hitting database most of the time. They prefer Integration over Controller
describe PeopleController do
  it "must have a index page" do
    get :index
    assert_template :index 
    # assert @response.success?
    assert_response :success
  end

  it "must show a form to create a Person" do
    get :new
    assert_response :success
    assert_template :new
  end

  describe "with a valid Person" do
    before do
      @person = Fabricate( :person, :name => "Patrick Negri", :age => 30 )
    end

    it "must have Patrick Negri on Index" do
      get :index
      # assert_match /Patrick Negri/, @response.body
      assert_select 'td', 'Patrick Negri'
    end

    it "must show Patrick Negri details on Show" do
      get :show, :id => @person.id
      assert_response :success
    end
  end

  describe "create" do
    it "must render success when save" do
      assert_difference('Person.count') do
        post :create, :person => { :name => 'Patrick Negri', :age => 30 } 
      end
      assert_redirected_to person_path(assigns(:person))
      refute_empty flash[:notice]
    end
    it "must display form if have invalid fields" do
      post :create, :person => {}
      assert_response :success
      assert_template :new
    end
  end 

end

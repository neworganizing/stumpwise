# Copyright (c) 2010-2011 ProgressBound, Inc.
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'test_helper'

class Manage::ThemesControllerTest < ActionController::TestCase
=begin    
  context "with administrator logged in" do
    setup { login_as(:admin) }
    
    context "on GET to :index" do
      setup { get :index }
      
      should_respond_with :success
      should_render_with_layout :manage
      should_render_template :index
      should_not_set_the_flash
      should_assign_to :themes
    
      should "return a list of all themes" do
        assert_equal Theme.count, assigns(:themes).size
      end
    end
    
    context "on GET to :show" do
      setup { get :show, :id => 1 }
      
      should_respond_with :success
      should_render_with_layout :manage
      should_render_template :show
      should_not_set_the_flash
      should_assign_to :theme
    end

    context "on GET to :new" do
      setup { get :new }
      
      should_respond_with :success
      should_render_with_layout :manage
      should_render_template :new
      should_not_set_the_flash
      should_assign_to :theme
    end
    
    context "on POST to :create with a valid theme" do
      setup do
        Theme.any_instance.expects(:save).returns(true).once
        post :create, {:theme => Factory.attributes_for(:theme)}
      end
      
      should_redirect_to("themes listing"){ manage_themes_path }
      should_not_set_the_flash
      should_create :theme
      should_assign_to :theme
    end
    
    context "on POST to :create with an invalid theme" do
      setup do
        Theme.any_instance.expects(:save).returns(false).once
        post :create, {:theme => Factory.attributes_for(:theme)}
      end
      
      should_respond_with :success
      should_render_with_layout :manage
      should_render_template :new
      should_assign_to :theme
    end

    context "on GET to :edit" do
      setup { get :edit, :id => 1 }
      should_respond_with :success
      should_render_with_layout :manage
      should_render_template :edit
      should_assign_to :theme
      should_not_set_the_flash
    end
    
    context "on PUT to :update with valid attributes" do
      setup do
        Theme.any_instance.expects(:update_attributes).returns(true).once
        put :update, {:id => 1, :theme => {:name => "New Name"}}
      end
      
      should_redirect_to("themes listing"){ manage_themes_path }
    end
    
    context "on PUT to :update with invalid attributes" do
      setup do
        Theme.any_instance.expects(:update_attributes).returns(false).once
        put :update, {:id => 1, :theme => {:name => "New Name"}}
      end
      
      should_respond_with :success
      should_render_with_layout :manage
      should_render_template :edit
      should_assign_to :theme
    end
    
    context "on DELETE to :destroy with record that can be destroyed" do
      setup do
        Theme.any_instance.expects(:destroy).returns(true).once
        delete :destroy, :id => 1
      end
      
      should_redirect_to("themes listing"){ manage_themes_path }
    end
  end
=end
  
  context "with authorized user but non-administrator logged in" do
    setup { login_as(:authorized) }
    
    context "on GET to :index" do
      setup { get :index }
      should_redirect_to("super admin login"){ manage_login_path }
    end

    context "on GET to :new" do
      setup { get :new }
      should_redirect_to("super admin login"){ manage_login_path }
    end

    context "on POST to :create" do
      setup { post :create }
      should_redirect_to("super admin login"){ manage_login_path }
    end

    context "on GET to :show" do
      setup { get :show, :id => 1 }
      should_redirect_to("super admin login"){ manage_login_path }
    end

    context "on GET to :edit" do
      setup { get :edit, :id => 1 }
      should_redirect_to("super admin login"){ manage_login_path }
    end
    
    context "on PUT to :update" do
      setup { put :update, :id => 1 }
      should_redirect_to("super admin login"){ manage_login_path }
    end
    
    context "on DELETE to :destroy" do
      setup { delete :destroy, :id => 1 }
      should_redirect_to("super admin login"){ manage_login_path }
    end
  end

  context "with unauthorized user logged in" do
    setup { login_as(:unauthorized) }

    context "on GET to :index" do
      setup { get :index }
      should_redirect_to("super admin login"){ manage_login_path }
    end

    context "on GET to :new" do
      setup { get :new }
      should_redirect_to("super admin login"){ manage_login_path }
    end

    context "on GET to :show" do
      setup { get :show, :id => 1 }
      should_redirect_to("super admin login"){ manage_login_path }
    end

    context "on POST to :create" do
      setup { post :create }
      should_redirect_to("super admin login"){ manage_login_path }
    end

    context "on GET to :edit" do
      setup { get :edit, :id => 1 }
      should_redirect_to("super admin login"){ manage_login_path }
    end
    
    context "on PUT to :update" do
      setup { put :update, :id => 1 }
      should_redirect_to("super admin login"){ manage_login_path }
    end
    
    context "on DELETE to :destroy" do
      setup { delete :destroy, :id => 1 }
      should_redirect_to("super admin login"){ manage_login_path }
    end
  end
end

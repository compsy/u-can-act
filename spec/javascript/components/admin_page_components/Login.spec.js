import React from 'react'
import {shallow} from 'enzyme'
import Login from 'components/admin_page_components/Login'

describe('Login', () => {
  let wrapper;
  let dummy_auth;

  beforeEach(() => {
    dummy_auth = {login: jest.fn(), isAuthenticated: jest.fn(), logout: jest.fn()}
    wrapper = shallow(<Login auth={dummy_auth}/>)
  });

  describe('login', () => {
    it("it should call the login function of the provided auth attribute", () => {
      expect(dummy_auth.login).not.toHaveBeenCalled()
      wrapper.instance().login();
      expect(dummy_auth.login).toHaveBeenCalled()
    });
  });

  describe('logout', () => {
    it("it should call the logout function of the provided auth attribute", () => {
      expect(dummy_auth.logout).not.toHaveBeenCalled()
      wrapper.instance().logout();
      expect(dummy_auth.logout).toHaveBeenCalled()
    });
  });

  describe('loginLogoutButton', () => {
    it("it should return a logout button of the person is currently logged in", () => {
      const logged_in = true;
      const result = wrapper.instance().loginLogoutButton(logged_in);
      expect(result.type).toEqual('a');
      expect(result.props.className).toEqual('waves-effect waves-light btn login-button');
      expect(result.props.children).toEqual('Log Out');
      expect(result.props.onClick.name.endsWith('logout')).toBeTruthy();
    });

    it("it should return a login button if the person is currently logged out", () => {
      const logged_in = false;
      const result = wrapper.instance().loginLogoutButton(logged_in);
      expect(result.type).toEqual('a');
      expect(result.props.className).toEqual('waves-effect waves-light btn login-button');
      expect(result.props.children).toEqual('Log In');
      expect(result.props.onClick.name.endsWith('login')).toBeTruthy();
    });
  });

  describe('render', () => {
    it("it should call the loginLogoutButton with true when the person is authenticated", () => {
      const spy = jest.spyOn(Login.prototype, 'loginLogoutButton')
      wrapper = shallow(<Login auth={{
        isAuthenticated: () => true
      }}/>)
      expect(Login.prototype.loginLogoutButton).toHaveBeenCalledWith(true)
      expect(Login.prototype.loginLogoutButton).toHaveBeenCalledTimes(1)
      spy.mockRestore();
    });
    it("it should call the loginLogoutButton with false when the person is not authenticated", () => {
      const spy = jest.spyOn(Login.prototype, 'loginLogoutButton')
      wrapper = shallow(<Login auth={{
        isAuthenticated: () => false
      }}/>)
      expect(Login.prototype.loginLogoutButton).toHaveBeenCalledWith(false)
      expect(Login.prototype.loginLogoutButton).toHaveBeenCalledTimes(1)
      spy.mockRestore();
    });
  });
});

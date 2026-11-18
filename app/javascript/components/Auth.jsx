let session = null;

export default class Auth {
  constructor() {
    this.login = this.login.bind(this);
    this.logout = this.logout.bind(this);
    this.handleAuthentication = this.handleAuthentication.bind(this);
    this.isAuthenticated = this.isAuthenticated.bind(this);

    // Copy the correct auth0 env vars here.
    this.auth0 = new auth0.WebAuth({
      domain: process.env.AUTH0_DOMAIN,
      clientID: process.env.AUTH0_CLIENT_ID,
      redirectUri: process.env.AUTH0_REDIRECT_URL,
      audience: process.env.AUTH0_AUDIENCE,
      responseType: 'token id_token',
      scope: 'openid'
    });
    this.history = History.createBrowserHistory();
  }


  login() {
    this.auth0.authorize({ appState: { returnTo: window.location.pathname } });
  }

  handleAuthentication(history) {
    this.auth0.parseHash((err, authResult) => {
      if (authResult && authResult.accessToken && authResult.idToken) {
        this.setSession(authResult);
      } else if (err) {
        console.log(err);
      }

      const returnTo = authResult && authResult.appState && authResult.appState.returnTo;
      history.replace(returnTo && returnTo.startsWith('/admin') ? returnTo : '/admin');
    });
  }

  setSession(authResult) {
    session = {
      accessToken: authResult.accessToken,
      idToken: authResult.idToken,
      expiresAt: (authResult.expiresIn * 1000) + new Date().getTime()
    };
  }

  static idToken() {
    return session && session.idToken;
  }

  logout() {
    session = null;

    // navigate back to the admin route
    this.history.replace('/admin');
    location.reload();
  }

  isAuthenticated() {
    return session !== null && new Date().getTime() < session.expiresAt;
  }
}

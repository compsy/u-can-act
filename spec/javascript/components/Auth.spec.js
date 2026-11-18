import Auth from 'Auth'

describe('Auth', () => {
  const authResult = { accessToken: 'access', idToken: 'id', expiresIn: 60 }

  beforeEach(() => {
    localStorage.clear()
  })

  describe('setSession', () => {
    it('keeps the tokens in memory and not in localStorage', () => {
      Auth.prototype.setSession(authResult)

      expect(Auth.idToken()).toEqual('id')
      expect(Auth.prototype.isAuthenticated()).toBe(true)
      expect(localStorage.length).toEqual(0)
    })

    it('is not authenticated after the token expires', () => {
      Auth.prototype.setSession({ ...authResult, expiresIn: -1 })

      expect(Auth.prototype.isAuthenticated()).toBe(false)
    })
  })
})

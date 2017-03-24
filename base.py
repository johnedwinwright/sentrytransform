import json, logger
from masheryV2 import MasheryV2

class Base:

    def __init__(self, protocol, api_host, site_id, apikey, secret):
        self.masheryV2 = MasheryV2(protocol, api_host)
        self.site_id = site_id
        self.apikey = apikey
        self.secret = secret
        self.logger = logger

    def area_fetch(self):
        try:
            if (self.logger != None):
                self.logger.info('API METHOD: %s', '{"method":"area.fetch","id":1,"params":[]}')

            result = self.masheryV2.post(self.site_id, self.apikey, self.secret, '{"method":"area.fetch","id":1,"params":[]}')
            if (self.logger != None):
                self.logger.info('RESPONSE: %s', json.dumps(result))

            return result['result']

        except ValueError as err:
            if (self.logger != None):
                self.logger.error('ERROR: %s', json.dumps(err.args))
            raise ValueError(err.args)

        return None

    def object_describe(self, object_type):
        try:
            method = '{"method":"object.describe","id":1,"params":[["'+object_type+'"]]}'
            if (self.logger != None):
                self.logger.info('API METHOD: %s', method)

            result = self.masheryV2.post(self.site_id, self.apikey, self.secret, method)
            if (self.logger != None):
                self.logger.info('RESPONSE: %s', json.dumps(result))

            return result['result']

        except ValueError as err:
            if (self.logger != None):
                self.logger.error('ERROR: %s', json.dumps(err.args))
            raise ValueError(err.args)

        return None

    def fetch(self, object_type, fields, filter_clause, limit=100):
      results = []
      try:
          method = '{"method":"object.query","id":1,"params":["select ' + fields + ' from ' + object_type + ' ' + filter_clause + ' ITEMS ' + str(limit) + '"]}'
          result = self.masheryV2.post(self.site_id, self.apikey, self.secret, method)

          results.extend(result['result']['items'])
          total_pages = result['result']['total_pages']
          page = 1

          while (page < total_pages):
            page = page + 1
            method = '{"method":"object.query","id":1,"params":["select ' + fields + ' from ' + object_type + ' ' + filter_clause + ' PAGE ' + str(page) + ' ITEMS ' + str(limit) + '"]}'

            result = self.masheryV2.post(self.site_id, self.apikey, self.secret, method)
            results.extend(result['result']['items'])

      except ValueError as err:
        if (self.logger != None):
          self.logger.error('ERROR: %s', json.dumps(err.args))
        raise ValueError(err.args)

      return results

    def validate(self, object_type, item_data):
      result = []
      method = '{"method":"' + object_type + '.validate","id":1,"params":[' + json.dumps(item_data) + ']}'
      try:
          if (self.logger != None):
              self.logger.info('API METHOD: %s', method)

          result = self.masheryV2.post(self.site_id, self.apikey, self.secret, method)
          if (self.logger != None):
              self.logger.info('RESPONSE: %s', json.dumps(result))
          if result['result'] != True:
              raise ValueError(result)
          return result
      except ValueError as err:
          if (self.logger != None):
              self.logger.error('ERROR: %s', json.dumps(err.args))
          raise ValueError(err.args)

    def create(self, object_type, item_data):
      result = []
      method = '{"method":"' + object_type + '.create","id":1,"params":[' + json.dumps(item_data) + ']}'
      try:
          if (self.logger != None):
              self.logger.info('API METHOD: %s', method)

          result = self.masheryV2.post(self.site_id, self.apikey, self.secret, method)
          if (self.logger != None):
              self.logger.info('RESPONSE: %s', json.dumps(result))
          return result
      except ValueError as err:
          if (self.logger != None):
              self.logger.error('ERROR: %s', json.dumps(err.args))
          raise ValueError(err.args)

    def update(self, object_type, item_data):
      result = []
      method = '{"method":"' + object_type + '.update","id":1,"params":[' + json.dumps(item_data) + ']}'
      try:
          if (self.logger != None):
              self.logger.info('API METHOD: %s', method)

          result = self.masheryV2.post(self.site_id, self.apikey, self.secret, method)
          if (self.logger != None):
              self.logger.info('RESPONSE: %s', json.dumps(result))

          return result
      except ValueError as err:
          if (self.logger != None):
            self.logger.error('ERROR: %s', json.dumps(err.args))
          raise ValueError(err.args)

    def delete(self, object_type, item_data):
      result = []
      method = '{"method":"' + object_type + '.delete","id":1,"params":[' + json.dumps(item_data) + ']}'
      try:
          if (self.logger != None):
              self.logger.info('API METHOD: %s', method)

          result = self.masheryV2.post(self.site_id, self.apikey, self.secret, method)
          if (self.logger != None):
              self.logger.info('RESPONSE: %s', json.dumps(result))

          return result
      except ValueError as err:
          if (self.logger != None):
              self.logger.error('ERROR: %s', json.dumps(err.args))
          raise ValueError(err.args)

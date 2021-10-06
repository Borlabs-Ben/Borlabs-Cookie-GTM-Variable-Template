___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Borlabs Cookie Consent Variable",
  "description": "Consent variable for the Wordpress plugin \"Borlabs Cookie\". See our documentation article about the Google Tag Manager for more information. The link to the documentation is below.",
  "containerContexts": [
    "WEB"
  ],
  "categories": [
    "UTILITY",
    "TAG_MANAGEMENT"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "serviceName",
    "displayName": "Key of the service/cookie (f.e. google-analytics)",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const callInWindow = require('callInWindow');
const log = require('logToConsole');
const query = require('queryPermission');

log(data);

if (query('access_globals', 'execute', 'BorlabsCookie.checkCookieConsent')) {
  log('permission ok');
  return callInWindow('BorlabsCookie.checkCookieConsent', data.serviceName);
} else {
  log('permission failed');
  return false;
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "BorlabsCookie.checkCookieConsent"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: No permission returns false
  code: |-
    // arrange
    const log = require('logToConsole');
    const mockData = {
      serviceName: 'test-service'
    };
    mock('queryPermission', function() {
      return false;
    });
    mock('callInWindow', function(pathToFunction, argument1) {
      log(pathToFunction);
      return true;
    });

    // act
    let variableResult = runCode(mockData);

    // assert
    assertThat(variableResult).isEqualTo(false);
    assertApi('callInWindow').wasNotCalled();
    assertApi('logToConsole').wasCalledWith('permission failed');
- name: Permission ok returns value of checkCookieConsent
  code: |-
    // arrange
    const log = require('logToConsole');
    const mockData = {
      serviceName: 'test-service'
    };
    mock('callInWindow', function(pathToFunction, argument1) {
      log(pathToFunction);
      log(argument1);
      return true;
    });

    // act
    let variableResult = runCode(mockData);

    // assert
    assertThat(variableResult).isEqualTo(true);
    assertApi('callInWindow').wasCalledWith('BorlabsCookie.checkCookieConsent', mockData.serviceName);
    assertApi('logToConsole').wasCalledWith('permission ok');


___NOTES___

The variable returns true if the consent is given and false otherwise. This variable can be used to restrict a trigger to a given cookie consent.



/**
 * @flow
 * @relayHash e5787578fd26caf006aa1ccc53be2248
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
export type RelayExampleQueryVariables = {|
  key: string
|};
export type RelayExampleQueryResponse = {|
  +questionnaire: ?{|
    +title: ?string,
    +key: string,
    +name: string,
  |}
|};
export type RelayExampleQuery = {|
  variables: RelayExampleQueryVariables,
  response: RelayExampleQueryResponse,
|};
*/


/*
query RelayExampleQuery(
  $key: String!
) {
  questionnaire(key: $key) {
    title
    key
    name
    id
  }
}
*/

const node/*: ConcreteRequest*/ = (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "key",
    "type": "String!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "key",
    "variableName": "key",
    "type": "String!"
  }
],
v2 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "title",
  "args": null,
  "storageKey": null
},
v3 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "key",
  "args": null,
  "storageKey": null
},
v4 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "name",
  "args": null,
  "storageKey": null
};
return {
  "kind": "Request",
  "operationKind": "query",
  "name": "RelayExampleQuery",
  "id": null,
  "text": "query RelayExampleQuery(\n  $key: String!\n) {\n  questionnaire(key: $key) {\n    title\n    key\n    name\n    id\n  }\n}\n",
  "metadata": {},
  "fragment": {
    "kind": "Fragment",
    "name": "RelayExampleQuery",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": v0,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "questionnaire",
        "storageKey": null,
        "args": v1,
        "concreteType": "Questionnaire",
        "plural": false,
        "selections": [
          v2,
          v3,
          v4
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "RelayExampleQuery",
    "argumentDefinitions": v0,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "questionnaire",
        "storageKey": null,
        "args": v1,
        "concreteType": "Questionnaire",
        "plural": false,
        "selections": [
          v2,
          v3,
          v4,
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "id",
            "args": null,
            "storageKey": null
          }
        ]
      }
    ]
  }
};
})();
// prettier-ignore
(node/*: any*/).hash = '5b68483b21016c12d2c97e237e327964';
module.exports = node;

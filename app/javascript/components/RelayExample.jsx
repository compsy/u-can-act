import React from 'react'
import {graphql, QueryRenderer} from 'react-relay';
import relay from './relay';

export default class RelayExample extends React.Component {
  render() {
    return (
      <QueryRenderer
        environment={relay}
        query={graphql`
          query RelayExampleQuery($key: String!) {
            questionnaire(key: $key) {
              title
              key
              name
            }
          }`}
        variables={{
          key: "evaluatieonderzoek"
        }}
        render={({error, props}) => {
          if (error) {
            return <div>Error!</div>;
          }
          if (!props) {
            return <div>Loading...</div>;
          }
          return <div>Questionnaire title: {props.questionnaire.title}</div>;
        }}
      />
    );
  }
}

import React from 'react';

export default class TeamOverviewEntry extends React.Component {
  generateOverviewRows(overview, overviewName) {
    let rows = [];
    let cols = [];
    let entry = {};
    for (let i = 0, len = overview.length; i < len; i++) {
      cols = [];
      entry = overview[i];
      cols.push(<td key={`${entry.name}_name`}>{entry.name}</td>);
      cols.push(<td key={`${entry.name}_completion`}>{entry.completed}</td>);
      cols.push(<td key={`${entry.name}_percentage_completion`}>{entry.percentage_completed}%</td>);
      cols.push(<td key={`${entry.name}_met_threshold_completion`}>{entry.met_threshold_completion}</td>);
      cols.push(<td key={`${entry.name}_percentage_above_threshold`}>{entry.percentage_above_threshold}%</td>);
      rows.push(<tr key={`${entry.name}_${overviewName}`}>{cols}</tr>);
    }
    return rows;
  }

  generateTable(rows) {
    return (
      <table>
        <thead>
          <tr>
            <th>Team</th>
            <th>Completed</th>
            <th>Completed percentage</th>
            <th>&ge; 70% completed questionnaires</th>
            <th>% of mentors with &ge; 70% completed questionnaires</th>
          </tr>
        </thead>
        <tbody>{rows}</tbody>
      </table>
    );
  }

  render() {
    const rows = this.generateOverviewRows(this.props.overview, this.props.name);
    return (
      <div className='team-overview-entry col m12'>
        <h4>{this.props.name}</h4>
        {this.generateTable(rows)}
      </div>
    );
  }
}

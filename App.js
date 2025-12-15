import React, { useState } from 'react';
import Menu from './Menu';
import CommandPanel from './CommandPanel';
import './Dashboard.css';

const App = () => {
  const [selectedCommand, setSelectedCommand] = useState(null);

  const commands = [
    { name: 'Run Trivy Scan', id: 'run_scan' },
    { name: 'View Scan Summary', id: 'view_scan_summary' },
  ];

  return (
    <div className="dashboard">
      <div className="main-content">
        <Menu commands={commands} onSelectCommand={setSelectedCommand} />
        <CommandPanel command={selectedCommand} />
      </div>
    </div>
  );
};

export default App;

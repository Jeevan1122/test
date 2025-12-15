import React, { useState } from 'react';
import Menu from './Menu';
import CommandPanel from './CommandPanel';
import Chatbot from './components/Chatbot'; // Import the Chatbot component
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

      {/* Chatbot Integration */}
      <div className="chatbot-container">
        <Chatbot />
      </div>
    </div>
  );
};

export default App;

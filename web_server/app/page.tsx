'use client';
import { useState } from 'react';

export default function BlockerDashboard() {
  const [targetSite, setTargetSite] = useState('');
  const [status, setStatus] = useState('');

  const handleBlock = async () => {
    const res = await fetch('http://localhost:2345/block', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ sites: [targetSite] }),
    });
    if (res.ok) setStatus(`❌ Blocked ${targetSite}`);
    else setStatus('Error: Ensure Backend is running as Admin');
  };

  const handleUnblock = async () => {
    const res = await fetch('http://localhost:2345/unblock', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ sites: [targetSite] }),
    });
    if (res.ok) setStatus(`✅ Unblocked ${targetSite}`);
  };

  return (
    <div className="p-10 max-w-md mx-auto bg-gray-900 text-white rounded-xl">
      <h1 className="text-2xl font-bold mb-4">❄️ Cold Turkey Clone</h1>
      <p>Open the API docs at <a href="http://localhost:2345/docs" className="text-blue-400">http://localhost:2345/docs</a></p>
      <input 
        type="text" 
        className="w-full my-3 p-2 text-black rounded mb-4 bg-white"
        placeholder="facebook.com"
        value={targetSite}
        onChange={(e) => setTargetSite(e.target.value)}
      />
      
      <div className="flex gap-4">
        <button onClick={handleBlock} className="bg-red-500 px-4 py-2 rounded font-bold w-1/2">
          LOCK 🔒
        </button>
        <button onClick={handleUnblock} className="bg-green-500 px-4 py-2 rounded font-bold w-1/2">
          UNLOCK 🔓
        </button>
      </div>
      
      <p className="mt-4 text-center text-yellow-400">{status}</p>
    </div>
  );
}
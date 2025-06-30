import React from 'react'
import './layout.css'

export default function Layout({ children }) {
  return (
    <div className="app-layout">
      <header className="topbar">Topbar</header>
      <aside className="sidebar">SidebarLeft</aside>
      <main className="content">{children}</main>
      <footer className="footer">Footer</footer>
    </div>
  )
}


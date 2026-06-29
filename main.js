const { app, BrowserWindow, Menu, screen, session } = require('electron');
const path = require('path');

let mainWindow;

// ── Security: CSP header ──
const CSP = [
  "default-src 'self'",
  "script-src 'self' 'unsafe-inline'",
  "style-src 'self' 'unsafe-inline'",
  "img-src 'self' data: blob:",
  "font-src 'self'",
  "connect-src 'self' https://raw.githubusercontent.com",
  "form-action 'self'",
  "base-uri 'self'",
  "frame-ancestors 'none'",
].join('; ');

function createWindow() {
  const { width: screenW, height: screenH } = screen.getPrimaryDisplay().workAreaSize;
  const winW = Math.min(1100, Math.round(screenW * 0.75));
  const winH = Math.min(820, Math.round(screenH * 0.82));

  mainWindow = new BrowserWindow({
    width: winW,
    height: winH,
    minWidth: 780,
    minHeight: 560,
    center: true,
    title: '打字练习',
    backgroundColor: '#0f1117',
    webPreferences: {
      sandbox: true,
      nodeIntegration: false,
      contextIsolation: true,
      webSecurity: true,
      allowRunningInsecureContent: false,
    },
    icon: path.join(__dirname, 'icon-512.png')
  });

  // Remove default menu for clean look
  Menu.setApplicationMenu(null);

  // ── Security: block navigation / new windows ──
  mainWindow.webContents.setWindowOpenHandler(() => ({ action: 'deny' }));
  mainWindow.webContents.on('will-navigate', (event, url) => {
    if (!url.startsWith('file://')) event.preventDefault();
  });

  // ── Security: inject CSP ──
  session.defaultSession.webRequest.onHeadersReceived((details, callback) => {
    callback({
      responseHeaders: {
        ...details.responseHeaders,
        'Content-Security-Policy': [CSP],
      }
    });
  });

  mainWindow.loadFile('index.html');

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  // Keep app alive on macOS dock (standard behavior)
  if (process.platform !== 'darwin') app.quit();
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

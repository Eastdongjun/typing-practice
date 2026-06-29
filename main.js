const { app, BrowserWindow, Menu, screen } = require('electron');
const path = require('path');

let mainWindow;

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
      nodeIntegration: false,
      contextIsolation: true
    },
    icon: path.join(__dirname, 'icon-512.png')
  });

  // Remove default menu for clean look
  Menu.setApplicationMenu(null);

  mainWindow.loadFile('index.html');

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  app.quit();
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

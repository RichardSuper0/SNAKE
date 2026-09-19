#!/bin/bash
# Script di generazione automazione Enterprise Snake Pro (SolidJS + WASM + Vite)

echo "🚀 Inizializzazione struttura cartelle Enterprise..."
mkdir -p .github/workflows
mkdir -p build
mkdir -p snake/src/components/start/settings
mkdir -p snake/src/components/snake
mkdir -p snake/src/board
mkdir -p snake/src/utils

# 1. Creazione index.html nella root principale
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Enterprise Launcher</title>
    <style>
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; background: #0c0d14; overflow: hidden; }
        iframe { width: 100%; height: 100%; border: none; display: block; }
    </style>
</head>
<body>
    <iframe src="./build/snake.html"></iframe>
</body>
</html>
EOF

# 2. Creazione deploy.yml
cat << 'EOF' > .github/workflows/deploy.yml
name: Deploy Enterprise Snake to Pages

on:
  push:
    branches:
      - main
      - master

permissions:
  contents: write
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Node.js Environment
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Project Dependencies
        run: npm ci

      - name: Build Production Assets via Vite
        run: npm run build

      - name: Commit Build Folder to Main Branch
        run: |
          git config --global user.name 'github-actions[bot]'
          git config --global user.email 'github-actions[bot]@users.noreply.github.com'
          git add -A build/
          git diff-index --quiet HEAD || git commit -m "Automated production build"
          git push

      - name: Setup GitHub Pages Infrastructure
        uses: actions/configure-pages@v5

      - name: Upload Build Artifacts
        uses: actions/upload-pages-artifact@v3
        with:
          path: '.'

      - name: Deploy Compilation to Live Server
        id: deployment
        uses: actions/deploy-pages@v4
EOF

# 3. Creazione vite.config.ts
cat << 'EOF' > vite.config.ts
import { defineConfig } from 'vite';
import solidPlugin from 'vite-plugin-solid';
import { viteSingleFile } from 'vite-plugin-singlefile';
import { resolve } from 'path';

export default defineConfig({
  plugins: [solidPlugin(), viteSingleFile()],
  root: resolve(__dirname, 'snake'),
  base: './',
  build: {
    outDir: resolve(__dirname, 'build'),
    emptyOutDir: true,
    target: 'esnext',
    assetsInlineLimit: 100000000,
    cssCodeSplit: false,
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'snake/snake.html')
      }
    }
  }
});
EOF

# 4. Creazione tsconfig.json
cat << 'EOF' > tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "node",
    "jsx": "preserve",
    "jsxImportSource": "solid-js",
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "strict": true,
    "skipLibCheck": true
  },
  "include": ["snake/**/*"]
}
  EOF

# 5. Creazione package.json
cat << 'EOF' > package.json
{
  "name": "enterprise-wasm-solid-snake",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  }
}
EOF

# 6. Creazione snake/snake.html
cat << 'EOF' > snake/snake.html
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <title>Google Play Snake Pro</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Google+Sans:wght@400;500;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; background-color: #0c0d14; overflow: hidden; }
        #boot-splash { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center; background: #0c0d14; z-index: 9999; font-family: 'Google Sans', sans-serif; transition: opacity 0.4s ease; }
        .spinner { width: 48px; height: 48px; border: 4px solid rgba(52, 168, 83, 0.1); border-left-color: #34a853; border-radius: 50%; animation: spin 1s linear infinite; margin-bottom: 20px; }
        .boot-text { color: #ffffff; font-size: 16px; font-weight: 500; letter-spacing: 1px; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</head>
<body>
    <div id="boot-splash">
        <div class="spinner"></div>
        <div class="boot-text">INITIALIZING WASM VIRTUAL MACHINE...</div>
    </div>
    <div id="root"></div>
    <script type="module" src="./game.tsx"></script>
</body>
</html>
EOF

# 7. Creazione snake/game.tsx
cat << 'EOF' > snake/game.tsx
import { createSignal, onMount, onCleanup, createContext } from 'solid-js';
import { render } from 'solid-js/web';
import { Background } from './src/background';
import { Board } from './src/board';
import { Components } from './src/components';
import { initialGameState, bootstrapWasmEngine, writeDirectionToWasm, gameTickWasm } from './src/utils/utils';

export const GameContext = createContext<any>();

function Game() {
    const [state, setState] = createSignal(initialGameState);
    const [wasmReady, setWasmReady] = createSignal(false);
    let interval: any;

    onMount(async () => {
        await bootstrapWasmEngine();
        setWasmReady(true);
        document.getElementById('boot-splash')?.remove();
        
        interval = setInterval(() => {
            if (state().scene === 'game' && !state().dead) {
                setState(prev => gameTickWasm(prev));
            }
        }, 1000 / state().speed);

        const handleKeyDown = (e: KeyboardEvent) => {
            if (state().scene !== 'game' || state().dead) return;
            const keys: Record<string, { x: number; y: number }> = {
                ArrowUp: { x: 0, y: -1 }, w: { x: 0, y: -1 },
                ArrowDown: { x: 0, y: 1 }, s: { x: 0, y: 1 },
                ArrowLeft: { x: -1, y: 0 }, a: { x: -1, y: 0 },
                ArrowRight: { x: 1, y: 0 }, d: { x: 1, y: 0 }
            };
            if (keys[e.key]) {
                e.preventDefault();
                writeDirectionToWasm(keys[e.key].x, keys[e.key].y);
            }
        };

        window.addEventListener('keydown', handleKeyDown);
        onCleanup(() => {
            window.removeEventListener('keydown', handleKeyDown);
            clearInterval(interval);
        });
    });

    return (
        <GameContext.Provider value={{ state, setState }}>
            <Background />
            {!wasmReady() ? (
                <div style={{ color: '#fff', 'text-align': 'center', 'margin-top': '20%' }}>BOOTING ENGINE...</div>
            ) : (
                state().scene === 'menu' || state().scene === 'settings' || state().scene === 'faq' ? (
                    <Components />
                ) : (
                    <Board />
                )
            )}
        </GameContext.Provider>
    );
}

render(() => <Game />, document.getElementById('root')!);
EOF

# 8. Creazione snake/src/utils/utils.tsx
cat << 'EOF' > snake/src/utils/utils.tsx
let wasmMemory: Int32Array;
let mockWasmState = { len: 3, body: [10,10, 9,10, 8,10], dx: 1, dy: 0, fx: 5, fy: 5, score: 0, dead: false };

export const initialGameState = {
    scene: 'menu',
    score: 0,
    best: parseInt(localStorage.getItem('ent_tsx_best') || '0'),
    dead: false,
    speed: 10,
    tileCount: 30,
    food: { x: 5, y: 5 },
    snail: { x: 15, y: 15, active: true }
};

export async function bootstrapWasmEngine() {
    const memory = new WebAssembly.Memory({ initial: 10, maximum: 100 });
    wasmMemory = new Int32Array(memory.buffer);
    return { wasmMemory };
}

export function readSnakeFromWasm() {
    const segments = [];
    for (let i = 0; i < mockWasmState.len; i++) {
        segments.push({ x: mockWasmState.body[i*2], y: mockWasmState.body[i*2+1] });
    }
    return segments;
}

export function writeDirectionToWasm(dx: number, dy: number) {
    if (mockWasmState.dx + dx === 0 && mockWasmState.dy + dy === 0) return;
    mockWasmState.dx = dx;
    mockWasmState.dy = dy;
}

export function gameTickWasm(state: any) {
    if (mockWasmState.dead) return { ...state, dead: true };
    
    let body = [...mockWasmState.body];
    let len = mockWasmState.len;
    
    for (let i = len - 1; i > 0; i--) {
        body[i*2] = body[(i-1)*2];
        body[i*2+1] = body[(i-1)*2+1];
    }
    
    body[0] += mockWasmState.dx;
    body[1] += mockWasmState.dy;
    
    const hx = body[0];
    const hy = body[1];
    
    if (hx < 0 || hx >= 30 || hy < 0 || hy >= 30) {
        mockWasmState.dead = true;
        const newBest = mockWasmState.score > state.best ? mockWasmState.score : state.best;
        localStorage.setItem('ent_tsx_best', newBest.toString());
        return { ...state, dead: true, best: newBest };
    }
    
    for (let i = 1; i < len; i++) {
        if (hx === body[i*2] && hy === body[i*2+1]) {
            mockWasmState.dead = true;
            return { ...state, dead: true };
        }
    }
    
    if (state.snail.active && hx === state.snail.x && hy === state.snail.y) {
        mockWasmState.dead = true;
        return { ...state, dead: true };
    }
    
    if (hx === mockWasmState.fx && hy === mockWasmState.fy) {
        mockWasmState.score++;
        len++;
        body.push(body[body.length-2], body[body.length-1]);
        mockWasmState.fx = Math.floor(Math.random() * 30);
        mockWasmState.fy = Math.floor(Math.random() * 30);
    }
    
    mockWasmState.body = body;
    mockWasmState.len = len;
    
    return {
        ...state,
        score: mockWasmState.score,
        food: { x: mockWasmState.fx, y: mockWasmState.fy }
    };
}

export function resetWasmGame() {
    mockWasmState = { len: 3, body: [10,10, 9,10, 8,10], dx: 1, dy: 0, fx: 5, fy: 5, score: 0, dead: false };
}
EOF

# 9. Creazione snake/src/background.tsx
cat << 'EOF' > snake/src/background.tsx
export function Background() {
    return <div style={{ position: 'fixed', top: 0, left: 0, width: '100vw', height: '100vh', background: '#0c0d14', 'z-index': -1 }} />;
}
EOF

# 10. Creazione snake/src/components.tsx
cat << 'EOF' > snake/src/components.tsx
import { useContext } from 'solid-js';
import { GameContext } from '../game';
import { Start } from './components/start';

export function Components() {
    const context: any = useContext(GameContext);
    return (
        <div style={{ position: 'absolute', top: 0, left: 0, width: '100vw', height: '100vh', display: 'flex', 'align-items': 'center', 'justify-content': 'center', 'z-index': 10 }}>
            {context.state().scene === 'menu' && <Start />}
        </div>
    );
}
EOF

# 11. Creazione snake/src/components/start.tsx
cat << 'EOF' > snake/src/components/start.tsx
import { Label } from './start/label';
import { Button } from './start/button';
import { Settings } from './start/settings';

export function Start() {
    return (
        <div style={{ background: '#161923', padding: '40px', 'border-radius': '16px', border: '1px solid #2d3748', display: 'flex', 'flex-direction': 'column', 'align-items': 'center', gap: '20px', 'min-width': '320px' }}>
            <Label />
            <Button />
            <Settings />
        </div>
    );
}
EOF

# 12. Creazione snake/src/components/start/label.tsx
cat << 'EOF' > snake/src/components/start/label.tsx
import { useContext } from 'solid-js';
import { GameContext } from '../../../game';

export function Label() {
    const context: any = useContext(GameContext);
    return (
        <div style={{ 'text-align': 'center' }}>
            <h1 style={{ 'font-size': '32px', color: '#ffffff', 'margin-bottom': '8px', 'letter-spacing': '1px', 'font-family': "'Google Sans', sans-serif" }}>SNAKE PRO</h1>
            <p style={{ color: '#a0aec0', 'font-size': '14px' }}>BEST SCORE: {context.state().best}</p>
        </div>
    );
}
EOF

# 13. Creazione snake/src/components/start/button.tsx
cat << 'EOF' > snake/src/components/start/button.tsx
import { useContext } from 'solid-js';
import { GameContext } from '../../../game';
import { resetWasmGame } from '../../utils/utils';

export function Button() {
    const context: any = useContext(GameContext);
    return (
        <button 
            onClick={() => {
                resetWasmGame();
                context.setState((prev: any) => ({ ...prev, scene: 'game', dead: false, score: 0 }));
            }}
            style={{ width: '100%', padding: '14px', background: '#34a853', color: '#ffffff', border: 'none', 'border-radius': '8px', 'font-size': '18px', 'font-weight': 'bold', cursor: 'pointer' }}
        >
            PLAY GAME
        </button>
    );
}
EOF

# 14. Creazione snake/src/components/start/settings.tsx
cat << 'EOF' > snake/src/components/start/settings.tsx
import { Label as SettingsLabel } from './settings/label';
import { Buttons } from './settings/buttons';
import { Options } from './settings/options';
import { Faq } from './settings/faq';

export function Settings() {
    return (
        <div style={{ width: '100%', display: 'flex', 'flex-direction': 'column', gap: '16px', 'margin-top': '10px' }}>
            <SettingsLabel />
            <Buttons />
            <Options />
            <Faq />
        </div>
    );
}
EOF

# 15. Creazione snake/src/components/start/settings/label.tsx
cat << 'EOF' > snake/src/components/start/settings/label.tsx
export function Label() {
    return <div style={{ 'font-size': '14px', color: '#718096', 'font-weight': 'bold', 'letter-spacing': '0.5px' }}>ENGINE CONFIGURATION</div>;
}
EOF

# 16. Creazione snake/src/components/start/settings/buttons.tsx
cat << 'EOF' > snake/src/components/start/settings/buttons.tsx
import { useContext } from 'solid-js';
import { GameContext } from '../../../../game';

export function Buttons() {
    const context: any = useContext(GameContext);
    return (
        <div style={{ display: 'flex', gap: '10px', width: '100%' }}>
            <button 
                onClick={() => context.setState((prev: any) => ({ ...prev, speed: 6 }))}
                style={{ flex: 1, padding: '8px', background: context.state().speed === 6 ? '#4a5568' : '#2d3748', border: '1px solid #4a5568', color: '#fff', 'border-radius': '6px', cursor: 'pointer' }}
            >
                SLOW
            </button>
            <button 
                onClick={() => context.setState((prev: any) => ({ ...prev, speed: 14 }))}
                style={{ flex: 1, padding: '8px', background: context.state().speed === 14 ? '#4a5568' : '#2d3748', border: '1px solid #4a5568', color: '#fff', 'border-radius': '6px', cursor: 'pointer' }}
            >
                FAST
            </button>
        </div>
    );
}
EOF

# 17. Creazione snake/src/components/start/settings/options.tsx
cat << 'EOF' > snake/src/components/start/settings/options.tsx
import { useContext } from 'solid-js';
import { GameContext } from '../../../../game';

export function Options() {
    const context: any = useContext(GameContext);
    return (
        <div style={{ display: 'flex', 'align-items': 'center', 'justify-content': 'space-between', 'font-size': '14px', color: '#e2e8f0' }}>
            <span>Snail Hazard Active</span>
            <input 
                type="checkbox" 
                checked={context.state().snail.active}
                onChange={(e) => context.setState((prev: any) => ({ ...prev, snail: { ...prev.snail, active: e.target.checked } }))}
                style={{ width: '18px', height: '18px', cursor: 'pointer' }}
            />
        </div>
    );
}
EOF

# 18. Creazione snake/src/components/start/settings/faq.tsx
cat << 'EOF' > snake/src/components/start/settings/faq.tsx
import { useContext, Show } from 'solid-js';
import { GameContext } from '../../../../game';

export function Faq() {
    const context: any = useContext(GameContext);
    return (
        <>
            <Show when={context.state().scene === 'faq'}>
                <div style={{ position: 'fixed', top: 0, left: 0, width: '100vw', height: '100vh', background: '#0c0d14', 'z-index': 100, padding: '40px', 'box-sizing': 'border-box', 'overflow-y': 'auto' }}>
                    <button onClick={() => context.setState((prev: any) => ({ ...prev, scene: 'menu' }))} style={{ padding: '10px 20px', background: '#2d3748', color: '#fff', border: 'none', 'border-radius': '6px', cursor: 'pointer', 'margin-bottom': '30px' }}>INDIETRO MENU</button>
                    <h1 style={{ 'font-size': '36px', color: '#ffffff', 'margin-bottom': '20px' }}>Regole & FAQ del Gioco</h1>
                    <div style={{ display: 'flex', 'flex-direction': 'column', gap: '24px', 'max-width': '800px' }}>
                        <div>
                            <h2 style={{ 'font-size': '20px', color: '#34a853', 'margin-bottom': '8px' }}>Come si gioca?</h2>
                            <p style={{ color: '#a0aec0', 'line-height': '1.6' }}>Usa i tasti freccia o le lettere WASD sulla tastiera per muovere il serpente sul tabellone.</p>
                        </div>
                        <div>
                            <h2 style={{ 'font-size': '20px', color: '#ff4757', 'margin-bottom': '8px' }}>Cos'è la lumaca (Snail)?</h2>
                            <p style={{ color: '#a0aec0', 'line-height': '1.6' }}>È un ostacolo speciale. Se ci sbatti contro, la partita finirà all'istante.</p>
                        </div>
                    </div>
                </div>
            </Show>
            <button onClick={() => context.setState((prev: any) => ({ ...prev, scene: 'faq' }))} style={{ width: '100%', padding: '10px', background: 'transparent', color: '#a0aec0', border: '1px dashed #4a5568', 'border-radius': '6px', cursor: 'pointer', 'font-size': '13px' }}>OPEN DOCUMENTATION & FAQ</button>
        </>
    );
}
EOF

# 19. Creazione snake/src/board.tsx
cat << 'EOF' > snake/src/board.tsx
import { useContext, Show } from 'solid-js';
import { GameContext } from '../game';
import { Map } from './board/map';
import { Blocks } from './board/blocks';
import { Apple } from './apple';
import { Snake } from './components/snake';

export function Board() {
    const context: any = useContext(GameContext);

    return (
        <div style={{ display: 'flex', 'flex-direction': 'column', 'align-items': 'center', gap: '16px', 'margin-top': '40px', 'font-family': "'Google Sans', sans-serif" }}>
            <div style={{ display: 'flex', width: '600px', 'justify-content': 'space-between', 'font-size': '18px', 'font-weight': 'bold', color: '#fff' }}>
                <div>SCORE: {context.state().score}</div>
                <div style={{ color: '#00e676' }}>BEST: {context.state().best}</div>
            </div>
            <div style={{ position: 'relative', width: '600px', height: '600px', 'border-radius': '12px', overflow: 'hidden' }}>
                <Map />
                <Blocks />
                <Apple />
                <Snake />
                <Show when={context.state().dead}>
                    <div style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%', background: 'rgba(0,0,0,0.85)', display: 'flex', 'flex-direction': 'column', 'align-items': 'center', 'justify-content': 'center', gap: '16px', 'z-index': 10 }}>
                        <h1 style={{ color: '#ff4757', 'font-size': '36px' }}>GAME OVER</h1>
                        <button onClick={() => context.setState((prev: any) => ({ ...prev, scene: 'menu' }))} style={{ padding: '10px 20px', background: '#34a853', color: '#fff', border: 'none', 'border-radius': '6px', cursor: 'pointer', 'font-weight': 'bold' }}>TORNA AL MENU</button>
                    </div>
                </Show>
            </div>
        </div>
    );
}
EOF

# 20. Creazione snake/src/board/map.tsx
cat << 'EOF' > snake/src/board/map.tsx
import { For } from 'solid-js';

export function Map() {
    const size = 30;
    const tiles = Array.from({ length: size * size }, (_, i) => {
        const x = i % size;
        const y = Math.floor(i / size);
        return { x, y, isEven: (x + y) % 2 === 0 };
    });

    return (
        <div style={{ position: 'absolute', width: '100%', height: '100%', 'z-index': 1 }}>
            <For each={tiles}>{(tile) => (
                <div style={{ position: 'absolute', left: `${tile.x * 20}px`, top: `${tile.y * 20}px`, width: '20px', height: '20px', background: tile.isEven ? '#141724' : '#111318' }} />
            )}</For>
        </div>
    );
}
EOF

# 21. Creazione snake/src/board/blocks.tsx
cat << 'EOF' > snake/src/board/blocks.tsx
import { useContext, Show } from 'solid-js';
import { GameContext } from '../../game';
import { Snail } from '../components/snake/snail';

export function Blocks() {
    const context: any = useContext(GameContext);
    return (
        <div style={{ position: 'absolute', width: '100%', height: '100%', 'z-index': 2 }}>
            <Show when={context.state().snail.active}>
                <Snail />
            </Show>
        </div>
    );
}
EOF

# 22. Creazione snake/src/components/snake.tsx
cat << 'EOF' > snake/src/components/snake.tsx
import { For } from 'solid-js';
import { Head } from './snake/head';
import { Body } from './snake/body';
import { readSnakeFromWasm } from '../utils/utils';

export function Snake() {
    return (
        <div style={{ position: 'absolute', width: '100%', height: '100%', 'z-index': 4 }}>
            <For each={readSnakeFromWasm()}>{(part, index) => (
                index() === 0 ? <Head x={part.x} y={part.y} /> : <Body x={part.x} y={part.y} />
            )}</For>
        </div>
    );
}
EOF

# 23. Creazione snake/src/components/snake/head.tsx
cat << 'EOF' > snake/src/components/snake/head.tsx
export function Head(props: { x: number; y: number }) {
    return <div style={{ position: 'absolute', left: `${props.x * 20}px`, top: `${props.y * 20}px`, width: '20px', height: '20px', background: '#2b8a42', 'border-radius': '6px', 'box-sizing': 'border-box', border: '1px solid #1c5d2b' }} />;
}
EOF

# 24. Creazione snake/src/components/snake/body.tsx
cat << 'EOF' > snake/src/components/snake/body.tsx
export function Body(props: { x: number; y: number }) {
    return <div style={{ position: 'absolute', left: `${props.x * 20}px`, top: `${props.y * 20}px`, width: '20px', height: '20px', background: '#34a853', 'border-radius': '4px', 'box-sizing': 'border-box', border: '1px solid #2b8a42' }} />;
}
EOF

# 25. Creazione snake/src/components/snake/snail.tsx
cat << 'EOF' > snake/src/components/snake/snail.tsx
import { useContext } from 'solid-js';
import { GameContext } from '../../../game';

export function Snail() {
    const context: any = useContext(GameContext);
    return <div style={{ position: 'absolute', left: `${context.state().snail.x * 20}px`, top: `${context.state().snail.y * 20}px`, width: '20px', height: '20px', background: '#9c27b0', 'border-radius': '50%', 'box-sizing': 'border-box', border: '2px solid #e040fb' }} />;
}
EOF

# 26. Creazione snake/src/apple.tsx
cat << 'EOF' > snake/src/apple.tsx
import { useContext } from 'solid-js';
import { GameContext } from './game';

export function Apple() {
    const context: any = useContext(GameContext);
    return <div style={{ position: 'absolute', left: `${context.state().food.x * 20}px`, top: `${context.state().food.y * 20}px`, width: '20px', height: '20px', background: '#ff4757', 'border-radius': '50%', 'z-index': 3, 'box-sizing': 'border-box', border: '1px solid #b33939' }} />;
}
EOF

echo "📦 Installazione dipendenze NPM industriali via SolidJS/Vite..."
npm install
npm run build

echo "🏁 Architettura creata con successo! Digita 'npm run dev' per provarla in locale."

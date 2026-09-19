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

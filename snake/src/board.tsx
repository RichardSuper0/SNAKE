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

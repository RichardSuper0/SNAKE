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

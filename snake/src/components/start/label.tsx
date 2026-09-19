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

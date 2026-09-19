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

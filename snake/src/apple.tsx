import { useContext } from 'solid-js';
import { GameContext } from './game';

export function Apple() {
    const context: any = useContext(GameContext);
    return <div style={{ position: 'absolute', left: `${context.state().food.x * 20}px`, top: `${context.state().food.y * 20}px`, width: '20px', height: '20px', background: '#ff4757', 'border-radius': '50%', 'z-index': 3, 'box-sizing': 'border-box', border: '1px solid #b33939' }} />;
}

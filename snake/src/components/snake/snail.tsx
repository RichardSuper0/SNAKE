import { useContext } from 'solid-js';
import { GameContext } from '../../../game';

export function Snail() {
    const context: any = useContext(GameContext);
    return <div style={{ position: 'absolute', left: `${context.state().snail.x * 20}px`, top: `${context.state().snail.y * 20}px`, width: '20px', height: '20px', background: '#9c27b0', 'border-radius': '50%', 'box-sizing': 'border-box', border: '2px solid #e040fb' }} />;
}

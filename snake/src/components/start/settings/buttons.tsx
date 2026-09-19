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

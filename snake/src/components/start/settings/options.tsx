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

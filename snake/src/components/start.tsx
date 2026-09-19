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

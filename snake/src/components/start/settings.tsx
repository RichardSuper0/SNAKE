import { Label as SettingsLabel } from './settings/label';
import { Buttons } from './settings/buttons';
import { Options } from './settings/options';
import { Faq } from './settings/faq';

export function Settings() {
    return (
        <div style={{ width: '100%', display: 'flex', 'flex-direction': 'column', gap: '16px', 'margin-top': '10px' }}>
            <SettingsLabel />
            <Buttons />
            <Options />
            <Faq />
        </div>
    );
}

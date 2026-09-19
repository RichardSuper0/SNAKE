import { useContext, Show } from 'solid-js';
import { GameContext } from '../../game';
import { Snail } from '../components/snake/snail';

export function Blocks() {
    const context: any = useContext(GameContext);
    return (
        <div style={{ position: 'absolute', width: '100%', height: '100%', 'z-index': 2 }}>
            <Show when={context.state().snail.active}>
                <Snail />
            </Show>
        </div>
    );
}

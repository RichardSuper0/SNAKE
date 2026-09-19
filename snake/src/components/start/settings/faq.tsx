import { useContext, Show } from 'solid-js';
import { GameContext } from '../../../../game';

export function Faq() {
    const context: any = useContext(GameContext);
    return (
        <>
            <Show when={context.state().scene === 'faq'}>
                <div style={{ position: 'fixed', top: 0, left: 0, width: '100vw', height: '100vh', background: '#0c0d14', 'z-index': 100, padding: '40px', 'box-sizing': 'border-box', 'overflow-y': 'auto' }}>
                    <button onClick={() => context.setState((prev: any) => ({ ...prev, scene: 'menu' }))} style={{ padding: '10px 20px', background: '#2d3748', color: '#fff', border: 'none', 'border-radius': '6px', cursor: 'pointer', 'margin-bottom': '30px' }}>INDIETRO MENU</button>
                    <h1 style={{ 'font-size': '36px', color: '#ffffff', 'margin-bottom': '20px' }}>Regole & FAQ del Gioco</h1>
                    <div style={{ display: 'flex', 'flex-direction': 'column', gap: '24px', 'max-width': '800px' }}>
                        <div>
                            <h2 style={{ 'font-size': '20px', color: '#34a853', 'margin-bottom': '8px' }}>Come si gioca?</h2>
                            <p style={{ color: '#a0aec0', 'line-height': '1.6' }}>Usa i tasti freccia o le lettere WASD sulla tastiera per muovere il serpente sul tabellone.</p>
                        </div>
                        <div>
                            <h2 style={{ 'font-size': '20px', color: '#ff4757', 'margin-bottom': '8px' }}>Cos'è la lumaca (Snail)?</h2>
                            <p style={{ color: '#a0aec0', 'line-height': '1.6' }}>È un ostacolo speciale. Se ci sbatti contro, la partita finirà all'istante.</p>
                        </div>
                    </div>
                </div>
            </Show>
            <button onClick={() => context.setState((prev: any) => ({ ...prev, scene: 'faq' }))} style={{ width: '100%', padding: '10px', background: 'transparent', color: '#a0aec0', border: '1px dashed #4a5568', 'border-radius': '6px', cursor: 'pointer', 'font-size': '13px' }}>OPEN DOCUMENTATION & FAQ</button>
        </>
    );
}

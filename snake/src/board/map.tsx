import { For } from 'solid-js';

export function Map() {
    const size = 30;
    const tiles = Array.from({ length: size * size }, (_, i) => {
        const x = i % size;
        const y = Math.floor(i / size);
        return { x, y, isEven: (x + y) % 2 === 0 };
    });

    return (
        <div style={{ position: 'absolute', width: '100%', height: '100%', 'z-index': 1 }}>
            <For each={tiles}>{(tile) => (
                <div style={{ position: 'absolute', left: `${tile.x * 20}px`, top: `${tile.y * 20}px`, width: '20px', height: '20px', background: tile.isEven ? '#141724' : '#111318' }} />
            )}</For>
        </div>
    );
}

import { For } from 'solid-js';
import { Head } from './snake/head';
import { Body } from './snake/body';
import { readSnakeFromWasm } from '../utils/utils';

export function Snake() {
    return (
        <div style={{ position: 'absolute', width: '100%', height: '100%', 'z-index': 4 }}>
            <For each={readSnakeFromWasm()}>{(part, index) => (
                index() === 0 ? <Head x={part.x} y={part.y} /> : <Body x={part.x} y={part.y} />
            )}</For>
        </div>
    );
}

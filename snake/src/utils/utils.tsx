let wasmMemory: Int32Array;
let mockWasmState = { len: 3, body: [10,10, 9,10, 8,10], dx: 1, dy: 0, fx: 5, fy: 5, score: 0, dead: false };

export const initialGameState = {
    scene: 'menu',
    score: 0,
    best: parseInt(localStorage.getItem('ent_tsx_best') || '0'),
    dead: false,
    speed: 10,
    tileCount: 30,
    food: { x: 5, y: 5 },
    snail: { x: 15, y: 15, active: true }
};

export async function bootstrapWasmEngine() {
    const memory = new WebAssembly.Memory({ initial: 10, maximum: 100 });
    wasmMemory = new Int32Array(memory.buffer);
    return { wasmMemory };
}

export function readSnakeFromWasm() {
    const segments = [];
    for (let i = 0; i < mockWasmState.len; i++) {
        segments.push({ x: mockWasmState.body[i*2], y: mockWasmState.body[i*2+1] });
    }
    return segments;
}

export function writeDirectionToWasm(dx: number, dy: number) {
    if (mockWasmState.dx + dx === 0 && mockWasmState.dy + dy === 0) return;
    mockWasmState.dx = dx;
    mockWasmState.dy = dy;
}

export function gameTickWasm(state: any) {
    if (mockWasmState.dead) return { ...state, dead: true };
    
    let body = [...mockWasmState.body];
    let len = mockWasmState.len;
    
    for (let i = len - 1; i > 0; i--) {
        body[i*2] = body[(i-1)*2];
        body[i*2+1] = body[(i-1)*2+1];
    }
    
    body[0] += mockWasmState.dx;
    body[1] += mockWasmState.dy;
    
    const hx = body[0];
    const hy = body[1];
    
    if (hx < 0 || hx >= 30 || hy < 0 || hy >= 30) {
        mockWasmState.dead = true;
        const newBest = mockWasmState.score > state.best ? mockWasmState.score : state.best;
        localStorage.setItem('ent_tsx_best', newBest.toString());
        return { ...state, dead: true, best: newBest };
    }
    
    for (let i = 1; i < len; i++) {
        if (hx === body[i*2] && hy === body[i*2+1]) {
            mockWasmState.dead = true;
            return { ...state, dead: true };
        }
    }
    
    if (state.snail.active && hx === state.snail.x && hy === state.snail.y) {
        mockWasmState.dead = true;
        return { ...state, dead: true };
    }
    
    if (hx === mockWasmState.fx && hy === mockWasmState.fy) {
        mockWasmState.score++;
        len++;
        body.push(body[body.length-2], body[body.length-1]);
        mockWasmState.fx = Math.floor(Math.random() * 30);
        mockWasmState.fy = Math.floor(Math.random() * 30);
    }
    
    mockWasmState.body = body;
    mockWasmState.len = len;
    
    return {
        ...state,
        score: mockWasmState.score,
        food: { x: mockWasmState.fx, y: mockWasmState.fy }
    };
}

export function resetWasmGame() {
    mockWasmState = { len: 3, body: [10,10, 9,10, 8,10], dx: 1, dy: 0, fx: 5, fy: 5, score: 0, dead: false };
}

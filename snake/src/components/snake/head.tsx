export function Head(props: { x: number; y: number }) {
    return <div style={{ position: 'absolute', left: `${props.x * 20}px`, top: `${props.y * 20}px`, width: '20px', height: '20px', background: '#2b8a42', 'border-radius': '6px', 'box-sizing': 'border-box', border: '1px solid #1c5d2b' }} />;
}

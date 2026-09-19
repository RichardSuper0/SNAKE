export function Body(props: { x: number; y: number }) {
    return <div style={{ position: 'absolute', left: `${props.x * 20}px`, top: `${props.y * 20}px`, width: '20px', height: '20px', background: '#34a853', 'border-radius': '4px', 'box-sizing': 'border-box', border: '1px solid #2b8a42' }} />;
}

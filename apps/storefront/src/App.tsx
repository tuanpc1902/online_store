import { useEffect, useState } from 'react'

type Health = { status: string; service: string; timestamp: string }
const categories = [
  { name: 'Audio', copy: 'Sound for focus and travel', symbol: '♫', color: 'lavender' },
  { name: 'Workspace', copy: 'Small upgrades, lasting impact', symbol: '⌘', color: 'peach' },
  { name: 'Outdoors', copy: 'Ready for the long way around', symbol: '↗', color: 'sage' },
]

export default function App() {
  const [api, setApi] = useState('Checking API')
  useEffect(() => {
    fetch('/api/v1/health').then(async (res) => {
      if (!res.ok) throw new Error('API unavailable')
      const result = await res.json() as Health
      setApi(result.status === 'ok' ? 'API connected' : 'API unavailable')
    }).catch(() => setApi('API not connected'))
  }, [])

  return <main className="shop">
    <div className="announcement">Complimentary delivery on orders over $75</div>
    <header><a className="logo" href="/">northstar<span>®</span></a><nav><a href="#shop">Shop</a><a href="#story">Our story</a><a href="#journal">Journal</a></nav><div className="actions"><button>Search</button><button>Account</button><button>Bag (0)</button></div></header>
    <section className="hero"><div className="hero-copy"><p className="eyebrow">GOOD THINGS, WELL MADE</p><h1>Make room for<br/><em>better everyday.</em></h1><p className="intro">Considered essentials for your desk, your next trip, and all the moments in between.</p><a className="cta" href="#shop">Explore the collection <span>↗</span></a></div><div className="hero-art"><div className="sun"></div><div className="arch"></div><div className="object"></div><div className="object small"></div><span>OBJECTS FOR THE IN-BETWEEN</span></div></section>
    <section className="collections" id="shop"><div className="section-title"><div><p className="eyebrow">THE SHORTLIST</p><h2>Find your kind of good.</h2></div><a href="#all">Shop all ↗</a></div><div className="grid">{categories.map((item, i) => <a href="#all" className={'tile ' + item.color} key={item.name}><small>0{i + 1} / COLLECTION</small><b>{item.symbol}</b><div><h3>{item.name}</h3><p>{item.copy}</p></div><span className="arrow">↗</span></a>)}</div></section>
    <footer><a className="logo" href="/">northstar<span>®</span></a><span>Made for the pace of real life.</span><span className="api">{api}</span></footer>
  </main>
}

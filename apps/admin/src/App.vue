<script setup lang="ts">
import { onMounted, ref } from 'vue'

type ApiHealth = { status: string; service: string; timestamp: string }
const apiState = ref('Checking API')
const stats = [
  { label: 'Orders today', value: '—', note: 'Awaiting order API', icon: '↗' },
  { label: 'Gross sales', value: '—', note: 'Awaiting reporting API', icon: '$' },
  { label: 'Low stock', value: '—', note: 'Awaiting inventory API', icon: '◉' },
  { label: 'Open returns', value: '—', note: 'Awaiting returns API', icon: '↩' },
]
const tasks = [
  { title: 'Orders to fulfill', description: 'Paid orders waiting to ship', count: '12', icon: '!', tone: 'amber' },
  { title: 'Low-stock products', description: 'Reorder before inventory runs out', count: '4', icon: '◉', tone: 'coral' },
  { title: 'Returns to review', description: 'Requests awaiting a decision', count: '3', icon: '↩', tone: 'blue' },
  { title: 'Purchase orders due', description: 'Supplier deliveries this week', count: '2', icon: '⌁', tone: 'green' },
]
const orders = [
  { id: '#ORD-2026-00042', customer: 'Minh Tran', date: 'Today, 10:42 am', status: 'Processing', payment: 'Paid', total: '$248.00' },
  { id: '#ORD-2026-00041', customer: 'Linh Nguyen', date: 'Today, 9:18 am', status: 'Shipped', payment: 'Paid', total: '$129.00' },
  { id: '#ORD-2026-00040', customer: 'Jordan Lee', date: 'Yesterday, 4:07 pm', status: 'Pending', payment: 'Pending', total: '$86.50' },
]

onMounted(async () => {
  try {
    const response = await fetch('/api/v1/health')
    if (!response.ok) throw new Error('API unavailable')
    const health = await response.json() as ApiHealth
    apiState.value = health.status === 'ok' ? 'API connected' : 'API unavailable'
  } catch {
    apiState.value = 'API not connected'
  }
})
</script>

<template>
  <div class="layout">
    <aside class="sidebar">
      <a class="brand" href="#"><span class="mark">N</span><span>northstar<small>STORE OPERATIONS</small></span></a>
      <p class="nav-label">WORKSPACE</p>
      <nav>
        <a class="nav-item active" href="#"><span>▦</span> Overview</a>
        <a class="nav-item" href="#"><span>▤</span> Orders <b>12</b></a>
        <a class="nav-item" href="#"><span>◫</span> Products</a>
        <a class="nav-item" href="#"><span>▧</span> Inventory</a>
        <a class="nav-item" href="#"><span>⇄</span> Purchasing</a>
        <a class="nav-item" href="#"><span>↗</span> Fulfillment</a>
        <a class="nav-item" href="#"><span>↩</span> Returns</a>
      </nav>
      <p class="nav-label manage-label">MANAGE</p>
      <nav><a class="nav-item" href="#"><span>♙</span> Customers</a><a class="nav-item" href="#"><span>⚙</span> Staff & access</a></nav>
      <div class="profile"><div class="avatar">AD</div><div><strong>Store Admin</strong><small>Administrator</small></div><span class="dots">···</span></div>
    </aside>

    <main class="main">
      <header class="topbar"><div class="crumb">Store operations <span>/</span> Overview</div><div class="top-actions"><span class="api-state"><i></i>{{ apiState }}</span><button aria-label="Notifications">♧</button><button class="help">Help center</button></div></header>
      <section class="page-heading"><div><p class="eyebrow">STORE OVERVIEW</p><h1>Good morning, Admin <span>✳</span></h1><p class="muted">Here’s what’s happening across your store today.</p></div><button class="date">Last 7 days <span>⌄</span></button></section>
      <section class="stats"><article class="stat" v-for="item in stats" :key="item.label"><div class="stat-label">{{ item.label }} <span>{{ item.icon }}</span></div><strong>{{ item.value }}</strong><small>{{ item.note }}</small></article></section>
      <section class="columns">
        <article class="panel"><div class="panel-head"><div><h2>Sales overview</h2><p>Revenue performance over time</p></div><button class="small-button">Weekly ⌄</button></div><div class="chart"><div class="y-labels"><span>$4k</span><span>$3k</span><span>$2k</span><span>$1k</span><span>$0</span></div><div class="chart-canvas"><div v-for="n in 5" :key="n" class="line"></div><svg viewBox="0 0 700 180" preserveAspectRatio="none"><defs><linearGradient id="wash" x1="0" x2="0" y1="0" y2="1"><stop offset="0" stop-color="#527d6d" stop-opacity=".2"/><stop offset="1" stop-color="#527d6d" stop-opacity="0"/></linearGradient></defs><path d="M0 140 C50 130 70 145 110 110 S175 120 215 91 S275 113 320 82 S380 104 420 57 S480 76 525 54 S590 70 635 26 S675 51 700 14 L700 180 L0 180Z" fill="url(#wash)"/><path d="M0 140 C50 130 70 145 110 110 S175 120 215 91 S275 113 320 82 S380 104 420 57 S480 76 525 54 S590 70 635 26 S675 51 700 14" fill="none" stroke="#527d6d" stroke-width="3"/></svg><div class="x-labels"><span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span><span>Sun</span></div></div></div></article>
        <article class="panel"><div class="panel-head"><div><h2>Needs attention</h2><p>Items that may need a follow-up</p></div><a class="quiet" href="#">View all ↗</a></div><a class="task" v-for="task in tasks" :key="task.title" href="#"><span class="task-icon" :class="task.tone">{{ task.icon }}</span><span class="task-copy"><strong>{{ task.title }}</strong><small>{{ task.description }}</small></span><b>{{ task.count }} <i>›</i></b></a></article>
      </section>
      <section class="panel order-panel"><div class="panel-head"><div><h2>Recent orders</h2><p>Most recent activity from your store</p></div><a class="quiet" href="#">All orders ↗</a></div><div class="table-scroll"><table><thead><tr><th>ORDER</th><th>CUSTOMER</th><th>DATE</th><th>STATUS</th><th>PAYMENT</th><th>TOTAL</th></tr></thead><tbody><tr v-for="order in orders" :key="order.id"><td><strong>{{ order.id }}</strong></td><td>{{ order.customer }}</td><td>{{ order.date }}</td><td><span class="pill" :class="order.status.toLowerCase()">{{ order.status }}</span></td><td><i class="payment-dot" :class="{ pending: order.payment === 'Pending' }"></i>{{ order.payment }}</td><td class="total">{{ order.total }}</td></tr></tbody></table></div></section>
      <footer><span>Northstar Store Operations</span><span>Help · Documentation · v0.1</span></footer>
    </main>
  </div>
</template>

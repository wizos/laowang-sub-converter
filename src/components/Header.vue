<template>
  <header class="topbar">
    <router-link to="/" class="brand" @click="closeMenu">
      <span class="brand-symbol">
        <Network :size="22" />
      </span>
      <span class="brand-copy">
        <strong>LaoWang</strong>
        <small>SUB OPS</small>
      </span>
    </router-link>

    <nav class="nav" :class="{ open: menuOpen }" aria-label="主导航">
      <router-link v-for="item in navItems" :key="item.to" :to="item.to" @click="closeMenu">
        <component :is="item.icon" :size="17" />
        <span>{{ item.label }}</span>
      </router-link>
    </nav>

    <div class="actions">
      <a
        class="icon-action"
        href="https://github.com/tony-wang1990/laowang-sub-converter"
        target="_blank"
        rel="noreferrer"
        title="GitHub"
      >
        <Github :size="19" />
      </a>
      <button class="icon-action menu-button" type="button" title="菜单" @click="toggleMenu">
        <X v-if="menuOpen" :size="20" />
        <Menu v-else :size="20" />
      </button>
    </div>
  </header>
</template>

<script setup>
import { ref } from 'vue'
import { Activity, Github, GitMerge, HeartPulse, Home, Link, Menu, Network, Rocket, X } from 'lucide-vue-next'

const menuOpen = ref(false)

const navItems = [
  { to: '/', label: '总览', icon: Home },
  { to: '/converter', label: '订阅转换', icon: Rocket },
  { to: '/merge', label: '订阅合并', icon: GitMerge },
  { to: '/health', label: '节点检测', icon: HeartPulse },
  { to: '/shortlink', label: '短链接', icon: Link },
  { to: '/about', label: '部署 API', icon: Activity }
]

const toggleMenu = () => {
  menuOpen.value = !menuOpen.value
}

const closeMenu = () => {
  menuOpen.value = false
}
</script>

<style scoped>
.topbar {
  position: fixed;
  top: 14px;
  left: 50%;
  z-index: 100;
  display: grid;
  grid-template-columns: auto minmax(0, 1fr) auto;
  align-items: center;
  gap: 12px;
  width: min(1240px, calc(100% - 28px));
  min-height: 66px;
  padding: 10px 12px;
  border: 1px solid rgba(135, 160, 185, 0.2);
  border-radius: var(--radius);
  background: rgba(5, 8, 13, 0.88);
  box-shadow: var(--shadow);
  backdrop-filter: blur(20px);
  transform: translateX(-50%);
}

.brand,
.brand-symbol,
.nav,
.nav a,
.actions,
.icon-action {
  display: flex;
  align-items: center;
}

.brand {
  gap: 11px;
  min-width: 0;
}

.brand-symbol {
  justify-content: center;
  width: 42px;
  height: 42px;
  border: 1px solid rgba(49, 214, 255, 0.42);
  border-radius: var(--radius);
  color: var(--accent);
  background: rgba(49, 214, 255, 0.09);
  box-shadow: inset 0 0 24px rgba(49, 214, 255, 0.08);
}

.brand-copy {
  display: grid;
  gap: 1px;
}

.brand-copy strong {
  color: var(--text);
  font-size: 1rem;
  font-weight: 900;
  line-height: 1;
}

.brand-copy small {
  color: var(--text-muted);
  font-family: var(--mono);
  font-size: 0.68rem;
  font-weight: 800;
  letter-spacing: 0.18em;
}

.nav {
  justify-content: center;
  gap: 5px;
  min-width: 0;
}

.nav a {
  gap: 7px;
  min-height: 42px;
  padding: 0 11px;
  border: 1px solid transparent;
  border-radius: var(--radius);
  color: var(--text-muted);
  font-size: 0.9rem;
  font-weight: 900;
  white-space: nowrap;
  transition: border-color 0.18s ease, background 0.18s ease, color 0.18s ease;
}

.nav a:hover,
.nav a.router-link-active {
  border-color: rgba(49, 214, 255, 0.26);
  color: var(--text);
  background: rgba(49, 214, 255, 0.08);
}

.nav a.router-link-active {
  color: var(--accent);
}

.actions {
  justify-content: flex-end;
  gap: 7px;
}

.icon-action {
  justify-content: center;
  width: 42px;
  height: 42px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  color: var(--text-soft);
  background: rgba(255, 255, 255, 0.04);
  cursor: pointer;
}

.icon-action:hover {
  border-color: var(--line-strong);
  color: var(--accent);
}

.menu-button {
  display: none;
}

@media (max-width: 1010px) {
  .topbar {
    grid-template-columns: auto auto;
    justify-content: space-between;
  }

  .menu-button {
    display: flex;
  }

  .nav {
    position: absolute;
    top: 76px;
    left: 0;
    right: 0;
    display: none;
    flex-direction: column;
    align-items: stretch;
    padding: 10px;
    border: 1px solid var(--line);
    border-radius: var(--radius);
    background: rgba(5, 8, 13, 0.96);
    box-shadow: var(--shadow);
  }

  .nav.open {
    display: flex;
  }

  .nav a {
    justify-content: flex-start;
    min-height: 46px;
  }
}

@media (max-width: 480px) {
  .brand-copy strong {
    max-width: 96px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}
</style>

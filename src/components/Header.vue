<template>
  <header class="topbar">
    <router-link to="/" class="brand" @click="closeMenu">
      <span class="brand-symbol">
        <span class="brand-monogram">LW</span>
        <span class="brand-signal" aria-hidden="true"></span>
      </span>
      <span class="brand-copy">
        <strong>LaoWang</strong>
        <small>SUB CONVERTER</small>
      </span>
    </router-link>

    <nav class="nav" :class="{ open: menuOpen }" aria-label="主导航">
      <router-link v-for="item in navItems" :key="item.to" :to="item.to" @click="closeMenu">
        <component :is="item.icon" :size="20" :stroke-width="2.2" />
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
        <Github :size="21" />
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
import { Activity, Github, GitMerge, HeartPulse, Home, Link, Menu, Rocket, X } from 'lucide-vue-next'

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
  top: 16px;
  left: 50%;
  z-index: 100;
  display: grid;
  grid-template-columns: auto minmax(0, 1fr) auto;
  align-items: center;
  gap: 22px;
  width: min(1440px, calc(100% - 32px));
  min-height: 82px;
  padding: 11px 14px;
  border: 1px solid rgba(135, 160, 185, 0.2);
  border-radius: 14px;
  background:
    linear-gradient(100deg, rgba(49, 214, 255, 0.055), transparent 28%),
    rgba(5, 8, 13, 0.92);
  box-shadow:
    0 24px 90px rgba(0, 0, 0, 0.48),
    inset 0 1px 0 rgba(255, 255, 255, 0.035);
  backdrop-filter: blur(24px);
  transform: translateX(-50%);
}

.topbar::after {
  content: '';
  position: absolute;
  right: 92px;
  bottom: -1px;
  left: 244px;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(49, 214, 255, 0.28), transparent);
  pointer-events: none;
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
  gap: 14px;
  min-width: 0;
  padding-right: 9px;
}

.brand-symbol {
  position: relative;
  justify-content: center;
  width: 58px;
  height: 58px;
  overflow: hidden;
  border: 1px solid rgba(49, 214, 255, 0.62);
  border-radius: 15px;
  color: #061018;
  background:
    linear-gradient(145deg, rgba(255, 255, 255, 0.8), transparent 36%),
    linear-gradient(135deg, var(--accent), var(--accent-2));
  box-shadow:
    0 12px 32px rgba(49, 214, 255, 0.2),
    inset 0 0 22px rgba(255, 255, 255, 0.18);
  transform: rotate(-3deg);
}

.brand-symbol::before {
  content: '';
  position: absolute;
  inset: 5px;
  border: 1px solid rgba(3, 16, 24, 0.2);
  border-radius: 10px;
}

.brand-monogram {
  position: relative;
  z-index: 1;
  font-family: var(--mono);
  font-size: 1.16rem;
  font-weight: 1000;
  letter-spacing: -0.12em;
  transform: translateX(-1px);
}

.brand-signal {
  position: absolute;
  right: 7px;
  bottom: 7px;
  width: 7px;
  height: 7px;
  border: 2px solid #061018;
  border-radius: 50%;
  background: var(--accent-2);
  box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.35);
}

.brand-copy {
  display: grid;
  gap: 4px;
}

.brand-copy strong {
  color: var(--text);
  font-size: 1.36rem;
  font-weight: 1000;
  line-height: 0.96;
  letter-spacing: -0.035em;
}

.brand-copy small {
  color: var(--accent);
  font-family: var(--mono);
  font-size: 0.66rem;
  font-weight: 900;
  letter-spacing: 0.14em;
}

.nav {
  justify-content: center;
  gap: 8px;
  min-width: 0;
}

.nav a {
  position: relative;
  gap: 7px;
  min-height: 54px;
  padding: 0 15px;
  border: 1px solid transparent;
  border-radius: 10px;
  color: #8fa1b7;
  font-size: 1rem;
  font-weight: 950;
  white-space: nowrap;
  transition: border-color 0.18s ease, background 0.18s ease, color 0.18s ease, transform 0.18s ease;
}

.nav a::after {
  content: '';
  position: absolute;
  right: 16px;
  bottom: 7px;
  left: 16px;
  height: 2px;
  border-radius: 999px;
  background: linear-gradient(90deg, var(--accent), var(--accent-2));
  opacity: 0;
  transform: scaleX(0.3);
  transition: opacity 0.18s ease, transform 0.18s ease;
}

.nav a:hover,
.nav a.router-link-active {
  border-color: rgba(49, 214, 255, 0.3);
  color: var(--text);
  background:
    linear-gradient(180deg, rgba(49, 214, 255, 0.12), rgba(49, 214, 255, 0.045));
  transform: translateY(-1px);
}

.nav a.router-link-active {
  color: var(--accent);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.04);
}

.nav a:hover::after,
.nav a.router-link-active::after {
  opacity: 1;
  transform: scaleX(1);
}

.actions {
  justify-content: flex-end;
  gap: 7px;
}

.icon-action {
  justify-content: center;
  width: 50px;
  height: 50px;
  border: 1px solid var(--line);
  border-radius: 12px;
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

@media (max-width: 1180px) {
  .topbar {
    grid-template-columns: auto auto;
    justify-content: space-between;
  }

  .menu-button {
    display: flex;
  }

  .nav {
    position: absolute;
    top: 94px;
    left: 0;
    right: 0;
    display: none;
    flex-direction: column;
    align-items: stretch;
    gap: 6px;
    padding: 12px;
    border: 1px solid var(--line);
    border-radius: 14px;
    background: rgba(5, 8, 13, 0.96);
    box-shadow: var(--shadow);
  }

  .nav.open {
    display: flex;
  }

  .nav a {
    justify-content: flex-start;
    min-height: 50px;
    padding: 0 16px;
  }
}

@media (max-width: 480px) {
  .topbar {
    top: 10px;
    width: calc(100% - 20px);
    min-height: 70px;
    padding: 8px 9px;
  }

  .brand {
    gap: 10px;
  }

  .brand-symbol {
    width: 48px;
    height: 48px;
    border-radius: 12px;
  }

  .brand-copy strong {
    max-width: 118px;
    overflow: hidden;
    font-size: 1.1rem;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .brand-copy small {
    font-size: 0.55rem;
    letter-spacing: 0.1em;
  }

  .icon-action {
    width: 44px;
    height: 44px;
  }

  .actions > a {
    display: none;
  }

  .nav {
    top: 78px;
  }
}
</style>

<template>
  <section class="panel client-selector">
    <div class="selector-head">
      <div>
        <p class="section-label">TARGET CLIENT</p>
        <h2>选择输出客户端</h2>
      </div>
      <span>{{ clients.length }} 个目标</span>
    </div>

    <div class="client-grid">
      <button
        v-for="client in clients"
        :key="client.id"
        type="button"
        class="client-card"
        :class="{ active: modelValue === client.id }"
        @click="$emit('update:modelValue', client.id)"
      >
        <component :is="client.icon" :size="19" />
        <span>
          <strong>{{ client.name }}</strong>
          <small>{{ client.platform }}</small>
        </span>
      </button>
    </div>
  </section>
</template>

<script setup>
import { Box, Flame, Gem, Monitor, Radio, Rocket, Shield, Smartphone, Sparkles, Waves, Zap } from 'lucide-vue-next'

defineProps({
  modelValue: {
    type: String,
    default: ''
  }
})

defineEmits(['update:modelValue'])

const clients = [
  { id: 'clashmeta', name: 'Clash Meta', platform: 'Meta YAML / 推荐', icon: Sparkles },
  { id: 'mihomo', name: 'Mihomo', platform: 'Meta 内核 YAML', icon: Sparkles },
  { id: 'stash', name: 'Stash', platform: 'iOS / macOS YAML', icon: Box },
  { id: 'singbox', name: 'sing-box', platform: '通用 JSON 配置', icon: Radio },
  { id: 'hiddify', name: 'Hiddify', platform: 'sing-box JSON', icon: Shield },
  { id: 'clash', name: 'Clash', platform: '经典 YAML', icon: Flame },
  { id: 'clashverge', name: 'Clash Verge', platform: '桌面客户端', icon: Monitor },
  { id: 'flclash', name: 'FlClash', platform: 'Flutter 客户端', icon: Monitor },
  { id: 'surge', name: 'Surge', platform: 'iOS / macOS CONF', icon: Waves },
  { id: 'quantumultx', name: 'Quantumult X', platform: 'iOS 配置片段', icon: Gem },
  { id: 'shadowrocket', name: 'Shadowrocket', platform: '分享链接', icon: Rocket },
  { id: 'loon', name: 'Loon', platform: 'iOS CONF', icon: Zap },
  { id: 'v2rayn', name: 'V2RayN', platform: 'Windows 分享链接', icon: Monitor },
  { id: 'v2rayng', name: 'V2RayNG', platform: 'Android 分享链接', icon: Smartphone },
  { id: 'v2rayu', name: 'V2RayU', platform: 'macOS 分享链接', icon: Monitor },
  { id: 'nekobox', name: 'NekoBox', platform: 'Android JSON', icon: Box },
  { id: 'surfboard', name: 'Surfboard', platform: 'Android CONF', icon: Waves },
  { id: 'sfa', name: 'SFA', platform: 'Android sing-box', icon: Smartphone },
  { id: 'sfi', name: 'SFI', platform: 'iOS sing-box', icon: Smartphone },
  { id: 'sfm', name: 'SFM', platform: 'macOS sing-box', icon: Monitor }
]
</script>

<style scoped>
.client-selector {
  display: grid;
  gap: 14px;
}

.selector-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

.selector-head h2 {
  margin: 0;
  color: var(--text);
  font-size: 1.18rem;
}

.selector-head > span {
  color: var(--text-muted);
  font-family: var(--mono);
  font-size: 0.78rem;
  font-weight: 900;
}

.client-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(186px, 1fr));
  gap: 10px;
}

.client-card {
  display: grid;
  grid-template-columns: 28px minmax(0, 1fr);
  align-items: center;
  gap: 11px;
  min-height: 76px;
  padding: 13px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  color: var(--text-soft);
  background: rgba(255, 255, 255, 0.035);
  cursor: pointer;
  text-align: left;
  transition: border-color 0.18s ease, background 0.18s ease, transform 0.18s ease;
}

.client-card:hover {
  border-color: var(--line-strong);
  transform: translateY(-1px);
}

.client-card.active {
  border-color: rgba(49, 214, 255, 0.72);
  color: var(--text);
  background: rgba(49, 214, 255, 0.1);
}

.client-card svg {
  color: var(--accent);
}

.client-card span {
  min-width: 0;
}

.client-card strong,
.client-card small {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.client-card strong {
  color: var(--text);
  font-size: 0.95rem;
  line-height: 1.22;
}

.client-card small {
  margin-top: 4px;
  color: var(--text-muted);
  font-size: 0.78rem;
  line-height: 1.35;
}
</style>

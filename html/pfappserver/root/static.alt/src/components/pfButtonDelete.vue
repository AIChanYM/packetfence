<template>
  <b-button-group
    :size="size" @mouseleave="stopInterrupt($event)"
    :class="['d-inline-flex', {'flex-row-reverse': reverse}]">
  <b-button
      v-if="!interrupt"
      type="button"
      :variant="variant"
      :disabled="disabled"
      @click.stop="startInterrupt($event)"
      ><slot>{{ $t('Delete') }}</slot></b-button>

    <b-button
      v-if="interrupt"
      type="button"
      variant="link"
      disabled
      >{{ confirm }}</b-button>
    <b-button
      v-if="interrupt"
      type="button"
      @click.stop="stopInterrupt($event)"
      @mousemove="startInterrupt($event)"
      @mouseover="startInterrupt($event)"
      >{{ $t('Cancel') }}</b-button>
    <b-button
      v-if="interrupt"
      type="button"
      variant="danger"
      @click.stop="onDelete($event)"
      @mousemove="startInterrupt($event)"
      @mouseover="startInterrupt($event)"
      >{{ $t('Delete') }}</b-button>
  </b-button-group>
</template>

<script>
import i18n from '@/utils/locale'

export default {
  name: 'pf-button-delete',
  props: {
    variant: {
      type: String,
      default: 'danger'
    },
    size: {
      type: String,
      default: ''
    },
    confirm: {
      type: String,
      default: i18n.t('Are you sure?')
    },
    interrupt: {
      type: Boolean,
      default: false
    },
    timeout: {
      type: Number,
      default: 3000
    },
    disabled: {
      type: Boolean,
      default: false
    },
    reverse: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    startInterrupt (event) {
      if (this.timerStop) clearTimeout(this.timerStop)
      this.interrupt = true
      this.timerStop = setTimeout(this.stopInterrupt, this.timeout)
    },
    stopInterrupt (event) {
      if (this.timerStop) clearTimeout(this.timerStop)
      this.interrupt = false
    },
    onDelete (event) {
      // emit to parent
      this.$emit('on-delete', event)
    }
  },
  beforeDestroy () {
    if (this.timerStop) {
      clearTimeout(this.timerStop)
    }
  }
}
</script>

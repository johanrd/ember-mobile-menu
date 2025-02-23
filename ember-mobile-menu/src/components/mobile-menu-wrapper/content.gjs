import Component from '@glimmer/component';
import { htmlSafe } from '@ember/template';
import didPan from 'ember-gesture-modifiers/modifiers/did-pan';
import MaskComponent from '../mobile-menu/mask.gjs';

const MODES = new Map([
  ['default', () => ''],
  ['push', (p) => `transform: translateX(${p}px);`],
  ['reveal', (p) => `transform: translateX(${p}px);`],
  ['ios', (p) => `transform: translateX(${p}px);`],
  ['squeeze', (p, side) => `margin-${side}: ${Math.abs(p)}px;`],
  ['squeeze-reveal', (p, side) => `margin-${side}: ${Math.abs(p)}px;`],
]);

/**
 * @class ContentComponent
 * @private
 */
export default class ContentComponent extends Component {
  /**
   * @argument mode
   * @type string
   * @protected
   */
  get mode() {
    return this.args.mode ?? 'default';
  }

  get style() {
    let styles = '';
    if (this.args.position > 0) {
      styles = MODES.get(this.mode)(this.args.position, 'left');
    } else if (this.args.position < 0) {
      styles = MODES.get(this.mode)(this.args.position, 'right');
    }

    return htmlSafe(styles);
  }

  get mask() {
    return ['reveal', 'ios'].includes(this.mode);
  }

  <template>
    <div
      class="mobile-menu-wrapper__content
        {{if @shadowEnabled 'mobile-menu-wrapper__content--shadow'}}
        mobile-menu-wrapper__content--{{this.mode}}"
      style={{this.style}}
      {{didPan
        onPanStart=@onPanStart
        onPan=@onPan
        onPanEnd=@onPanEnd
        capture=@capture
        preventScroll=@preventScroll
      }}
      ...attributes
    >
      {{yield}}

      {{#if this.mask}}
        <MaskComponent @isOpen={{@isOpen}} @onClick={{@onClose}} />
      {{/if}}
    </div>
  </template>
}

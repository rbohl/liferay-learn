    import 'dynamic-data-mapping-form-field-type/FieldBase/FieldBase.es';
    import './A3C9Register.soy.js';
    import templates from './A3C9.soy.js';
    import Component from 'metal-component';
    import Soy from 'metal-soy';
    import {Config} from 'metal-state';

    /**
     * A3C9 Component
     */
    class A3C9 extends Component {
    }

    A3C9.STATE = {

        name: Config.string().required(),

        predefinedValue: Config.oneOfType([Config.number(), Config.string()]),

        required: Config.bool().value(false),

        showLabel: Config.bool().value(true),

        spritemap: Config.string(),

        value: Config.string().value('')
    }

    // Register component
    Soy.register(A3C9, templates);

    export default A3C9;
